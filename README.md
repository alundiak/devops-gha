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


## `entrypoint.sh` permission

- `chmod a+x entrypoint.sh` gives `-rwxr-xr-x` and we need
- `chmod -R 775 entrypoint.sh` (aka `-rwxrwxr-x`)
- As result also need to change line in Dockerfile `RUN chmod 775 ./entrypoint.sh`


## Run locally

- `docker build -t my-entrypoint-test-img:latest --file Dockerfile .`
- `docker run --name=MyEntrypointContainer -d my-entrypoint-test-img:latest`

## Other commands to troubleshoot

- `docker run -it --rm --entrypoint /bin/bash my-entrypoint-test-img`
- `docker run  --entrypoint my-entrypoint-test-img "/bin/bash"` - WRONG syntax

