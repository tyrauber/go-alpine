FROM node:lts-alpine as base

FROM base as build

ARG \
  BUILD_TOOLS=" \
    bash \
    automake \
    autoconf \
    libtool \
    python3 \
    py-docutils \
    openjdk17-jre \
    nodejs \
    gcc \
    g++ \
    make \
    libstdc++ \
    git \
    tmux \
    wget \
    unzip \
    zip \
    curl"

RUN apk --update add $BUILD_TOOLS

COPY --from=golang:alpine3.17 /usr/local/go/ /usr/local/go/
ENV GOPATH=$HOME/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN GO111MODULE=on go install github.com/DarthSim/overmind/v2@latest

WORKDIR /app/

COPY Procfile .
COPY package.json .
COPY server.js .

RUN npm install --production

EXPOSE 8080
ENV PORT=8080

CMD overmind start