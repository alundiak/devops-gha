FROM node:21-alpine

WORKDIR /app
COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod 775 ./entrypoint.sh
ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]
