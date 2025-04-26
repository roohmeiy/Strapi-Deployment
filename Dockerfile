#Dockerfile for npm

FROM node:18-alpine3.18 AS build
# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
ENV NODE_OPTIONS="--max-old-space-size=4096"

WORKDIR /opt/
COPY package.json package-lock.json ./
RUN npm install -g node-gyp
RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN npm run build

FROM node:18-alpine3.18
RUN apk add --no-cache vips-dev
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV PATH=/opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["npm", "run", "develop"]


# # Build stage
# FROM node:18-alpine AS build
# WORKDIR /opt

# # Install only the dependencies needed for building
# RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev git > /dev/null 2>&1
# ENV NODE_OPTIONS="--max-old-space-size=4096"

# # Copy only package files first to leverage Docker cache
# COPY package.json package-lock.json ./
# RUN npm ci

# # Setup the app directory
# WORKDIR /opt/app

# # Copy project files
# COPY config ./config
# COPY database ./database
# COPY public ./public
# COPY src ./src
# COPY favicon.png ./favicon.png
# COPY tsconfig.json ./tsconfig.json
# COPY types ./types

# # Build the application
# RUN npm run build

# # Production stage
# FROM node:18-alpine AS production
# WORKDIR /opt
# ENV NODE_ENV=development

# # Install only production runtime dependencies
# RUN apk add --no-cache vips-dev

# # Copy only necessary files from build stage
# COPY --from=build /opt/package.json /opt/package-lock.json ./
# RUN npm ci --only=development

# # Create app directory
# WORKDIR /opt/app

# # Copy only what's needed from the build stage
# COPY --from=build /opt/app/build ./build
# COPY --from=build /opt/app/config ./config
# COPY --from=build /opt/app/database ./database
# COPY --from=build /opt/app/public ./public
# COPY --from=build /opt/app/favicon.png ./favicon.png

# # Set proper permissions and user
# RUN chown -R node:node /opt/app
# USER node
# EXPOSE 1337
# CMD ["npm", "run", "start"]