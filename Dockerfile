FROM node:20.11-bullseye AS build

# build nsecbunkerd
WORKDIR /app/nsecbunkerd
COPY ./nsecbunkerd/package*.json .
RUN npm install
COPY ./nsecbunkerd .
RUN npx prisma generate
RUN npm run build

# build nsecbunker-admin-ui
WORKDIR /app/nsecbunker-admin-ui
COPY ./nsecbunker-admin-ui/package*.json .
RUN npm install
COPY ./nsecbunker-admin-ui .
RUN npm run build

# Runtime stage
FROM node:20.11-alpine as runtime

RUN apk update && \
    apk add --no-cache openssl yq && \
    rm -rf /var/cache/apk/*

WORKDIR /app/nsecbunkerd
COPY --from=build /app/nsecbunkerd .
RUN npm install --only=production

WORKDIR /app/nsecbunker-admin-ui
COPY --from=build /app/nsecbunker-admin-ui .
RUN npm install --only=production

WORKDIR /app

EXPOSE 3000

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
