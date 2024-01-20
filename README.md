My DevOps GitHub Action
===

This is experimental, educational repository to build a custom GitHub Action.

Goal/behavior is TBD.

- Custom `action.yml` is designed to publish GitHub Action to Marketplace.
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


## Run locally

- `docker build -t my-entrypoint-test-img:latest --file Dockerfile .`
- `docker run --name=MyEntrypointContainer -d my-entrypoint-test-img:latest`
- `docker run -it --rm --entrypoint /bin/bash my-entrypoint-test-img`
- `docker run  --entrypoint my-entrypoint-test-img "/bin/bash"` - WRONG syntax
