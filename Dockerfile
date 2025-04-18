# Creating multi-stage build 
FROM node:18-alpine AS build
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev git > /dev/null 2>&1
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
# Add max old space size to prevent memory issues
ENV NODE_OPTIONS="--max-old-space-size=4096"


WORKDIR /opt/
COPY package.json package-lock.json ./
RUN yarn global add node-gyp
RUN yarn config set network-timeout 600000 -g && yarn install --production
ENV PATH=/opt/node_modules/.bin:$PATH
WORKDIR /opt/app
COPY . .
RUN yarn build



# Creating final image
FROM node:18-alpine
RUN apk add --no-cache vips-dev
ENV NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV PATH=/opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["yarn", "start"]