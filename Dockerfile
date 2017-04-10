FROM alpine:3.5
MAINTAINER Linki <linki+docker.com@posteo.de>

RUN apk add --no-cache \
  build-base           \
  linux-headers        \
  ruby-bundler         \
  ruby-dev             \
  ruby-io-console

RUN bundle config --global frozen 1

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/

RUN bundle install

COPY lib /app/lib
COPY config.ru /app/

CMD ["unicorn"]
