FROM node:15-buster AS builder

WORKDIR /usr/src/app
COPY package*.json ./

RUN yarn --no-cache

COPY . .
COPY .env.build .env
RUN yarn typecheck
RUN yarn build
RUN npm prune --production

FROM node:15-buster
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app .
RUN rm ./.env

EXPOSE 5000
CMD [ "yarn", "start:inject" ]