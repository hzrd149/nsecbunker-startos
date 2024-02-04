FROM node:20.11-bullseye AS build

WORKDIR /app

# Copy package files and install dependencies
COPY ./nsecbunkerd/package*.json ./
RUN npm install

# Copy application files
COPY ./nsecbunkerd .

# Generate prisma client and build the application
RUN npx prisma generate
RUN npm run build

# Runtime stage
FROM node:20.11-alpine as runtime

WORKDIR /app

RUN apk update && \
    apk add --no-cache openssl && \
    rm -rf /var/cache/apk/*

# Copy built files from the build stage
COPY --from=build /app .

# Install only runtime dependencies
RUN npm install --only=production

EXPOSE 3000

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh
