# Stage Base
FROM node:14-alpine AS base
RUN apk --no-cache add git
WORKDIR /app

# Stage Dependencies
FROM base AS dependencies
COPY package.json yarn.lock ./
RUN yarn install --prod

# Stage Build
FROM base AS build
COPY . .
RUN yarn install
RUN yarn build

# Stage Server
FROM node:14-alpine as server
WORKDIR /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/.env .env
COPY --from=build /app/package.json package.json

EXPOSE 3000
CMD [ "yarn", "start" ]