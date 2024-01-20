FROM node:21-alpine

WORKDIR /app

COPY entrypoint.sh ./entrypoint.sh

RUN chmod 775 ./entrypoint.sh

# Both works locally on MacOS host or inside of container

# GitHub Action error: 
# "/bin/sh: can't open './entrypoint.sh': No such file or directory"
# ENTRYPOINT ["/bin/sh", "./entrypoint.sh"] 

ENTRYPOINT ["sh", "./entrypoint.sh"] 

# GitHub Action error:
# docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: 
# unable to start container process: exec: "./entrypoint.sh": stat ./entrypoint.sh: no such file or directory: unknown.
# ENTRYPOINT ["./entrypoint.sh"]
