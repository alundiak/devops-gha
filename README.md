My DevOps GitHub Action
===

This is experimental, educational repository to build a custom GitHub Action.

## Usage in another GitHub Action YAML

```
...

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
        
      - name: Using my custom GitHub action
        uses: alundiak/devops-gha@main

...
```


## Goal/behavior is TBD

- Custom `action.yml` is a sign that my code can be published GitHub Action to Marketplace.
- For now it's just a Docker image using `ENTRYPOINT` command (a Docker layer).


## About `ENTRYPOINT`

Docker docs about [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)

```sh
ENTRYPOINT ["executable", "param1", "param2"]
ENTRYPOINT command param1 param2
```

> You can override the ENTRYPOINT setting using `--entrypoint`, but this can only set the binary to exec (no `sh -c` will be used).

- [Writing the action code](https://docs.github.com/en/enterprise-cloud@latest/actions/creating-actions/creating-a-docker-container-action?learn=create_actions&learnProduct=actions#writing-the-action-code)
- [Creating a Dockerfile](https://docs.github.com/en/enterprise-cloud@latest/actions/creating-actions/creating-a-docker-container-action?learn=create_actions&learnProduct=actions#creating-a-dockerfile)

=> `#!/bin/sh -l` for `entrypoint.sh`.


https://kinsta.com/blog/dockerfile-entrypoint/

```sh
# When this container starts, it launches a Python interpreter and executes the app.py script to act as your container’s default behavior.
ENTRYPOINT ["executable", "param1", "param2"] 

# This example starts the Python interpreter from a shell command instead of running it directly.
ENTRYPOINT python app.py 

# Unlike using ENTRYPOINT alone, this approach lets you override parameters passed during the docker run command.
ENTRYPOINT ["python", "app.py"]
CMD ["--help"]
```

- `docker run --entrypoint <image> “/bin/bash”` - WRONG syntax

Other about `ENTRYPOINT`:
- https://gist.github.com/drmalex07/669d7b15b0df33e249a2



## `entrypoint.sh` permission

- `chmod a+x entrypoint.sh` gives `-rwxr-xr-x` and we need
- `chmod -R 775 entrypoint.sh` (aka `-rwxrwxr-x`)
- As result also need to change line in Dockerfile `RUN chmod 775 ./entrypoint.sh`


## Shell (outside and inside)

Wiki [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

- `#!/bin/sh` – Execute the file using the Bourne shell, or a compatible shell, assumed to be in the /bin directory
- `#!/bin/bash` – Execute the file using the Bash shell
- `#!/usr/bin/pwsh` – Execute the file using PowerShell
- `#!/usr/bin/env` python3 – Execute with a Python interpreter, using the env program search path to find it
- `#!/bin/false` – Do nothing, but return a non-zero exit status, indicating failure. Used to prevent stand-alone execution of a script file intended for execution in a specific context, such as by the . command from sh/bash, source from csh/tcsh, or as a .profile, .cshrc, or .login file.


On my MacOS, as host environment I have both: `/bin/sh` and NO `/bin/bash`. 

GitHub Action environment seems to have `/usr/bin/sh` and `/usr/bin/bash`

My basic Dockerfile uses `FROM node:21-alpine` which give a bundle with ONLY one shell available from `/bin/sh`.

And initially I created `entrypoint.sh` file with `#!/bin/bash` which worked for me locally when I even built a Docker image on MacOS. But it fails on GitHub Action environment.

To prove that when I am inside of Docker container I executed 3 lines:

When execute `entrypoint.sh` (with `#!/bin/bash` or with `#!/bin/sh`) on MacOS host:

- $ `./entrypoint.sh` - OK
- $ `sh ./entrypoint.sh` - OK
- $ `bash ./entrypoint.sh` - OK

When execute `entrypoint.sh` (with `#!/bin/bash`) inside of Docker NodeJS container:

- /app # `./entrypoint.sh` - FAILS (/bin/sh: `./entrypoint.sh: not found`)
- /app # `sh ./entrypoint.sh` - OK
- /app # `bash ./entrypoint.sh` - FAILS (/bin/sh: `bash: not found`)

When execute `entrypoint.sh` (with `#!/bin/sh`) inside of Docker NodeJS container:

- /app # `./entrypoint.sh` - OK **IMPORTANT HERE**
- /app # `sh ./entrypoint.sh` - OK
- /app # `bash ./entrypoint.sh` - FAILS (/bin/sh: `bash: not found`)


**TL;DR**

For `node:21-alpine` image/container only `/bin/sh` is available inside, so shebang should be `#!/bin/sh`.

Note when `FROM ubuntu:latest` then inside of container:

```sh
# which sh
/usr/bin/sh

# which bash
/usr/bin/bash
```


And for `FROM node` (which is full v21 of image) it does have even 'dash':

```sh
# which sh
/usr/bin/sh

# which bash
/usr/bin/bash

# which dash
/usr/bin/dash
```

## Run locally

- `docker build -t my-entrypoint-test-img:latest --file Dockerfile .`
- `docker run --name=MyEntrypointContainer -d my-entrypoint-test-img:latest`

## Other commands to troubleshoot

- `docker run -it --rm --entrypoint /bin/bash my-entrypoint-test-img`
- `docker run  --entrypoint my-entrypoint-test-img "/bin/bash"` - WRONG syntax

