FROM alpine:3.5
MAINTAINER Linki <linki+docker.com@posteo.de>

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN apk add --no-cache --virtual build_deps \
      build-base                            \
      linux-headers                         \
      ruby-bundler                          \
      ruby-dev                           && \

    bundle config --global frozen 1      && \
    bundle install                       && \

    apk del build_deps

RUN apk add --no-cache ruby

COPY lib /app/lib
COPY config.ru /app/

CMD ["unicorn"]
