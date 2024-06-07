ARG RUBY_VERSION=3.1.3
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim


RUN apt-get update -qq && \
apt-get install --no-install-recommends -y build-essential git libvips pkg-config curl libsqlite3-0


WORKDIR /delivery


COPY . /delivery/



RUN bundle install
