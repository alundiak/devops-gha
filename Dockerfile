FROM node:21-alpine

WORKDIR /app

COPY entrypoint.sh ./entrypoint.sh

RUN chmod 775 ./entrypoint.sh

# Both works locally on MacOS host or inside of container
ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]
# ENTRYPOINT ["./entrypoint.sh"]
