ARG RUBY_IMAGE_VERSION
ARG BASE_IMAGE=ruby:${RUBY_IMAGE_VERSION}-slim-buster
FROM ${BASE_IMAGE}

ENV LANG=C.UTF-8

RUN mkdir /home/app
WORKDIR /home/app

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -qq --no-install-recommends \
  build-essential \
  git \
  < /dev/null > /dev/null \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

ENV GH_NPM_REGISTRY_TOKEN ""

# ENV vars that danger cares about
ENV GITHUB_TOKEN ""
ENV GITHUB_WORKFLOW ""
ENV GITHUB_EVENT_PATH ""
