# Build stage
FROM node:20-alpine AS builder

RUN apk upgrade --no-cache

WORKDIR /app

COPY package*.json ./

RUN npm install -g npm@10
RUN npm ci --omit=dev

COPY src ./src


# Runtime stage
FROM node:20-alpine

RUN apk upgrade --no-cache \
    && rm -rf /usr/local/lib/node_modules/npm \
              /usr/local/lib/node_modules/corepack \
              /usr/local/bin/npm \
              /usr/local/bin/npx \
              /usr/local/bin/corepack

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src

EXPOSE 3000

USER node

CMD ["node", "src/server.js"]
