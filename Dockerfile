FROM node:18.11-slim AS deps
#RUN apk add –no-cache libc6-compat
WORKDIR /app
COPY src/package.json src/package-lock.json ./
RUN npm install

FROM node:18.11-slim AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY ./src .
RUN npm run build

FROM node:18.11-slim AS runner
WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static
RUN npm install -g serve
EXPOSE 3000
CMD [ "serve", "-s", "build", "-l", "3000" ]
