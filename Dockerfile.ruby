ARG RUBY_IMAGE_VERSION
ARG BASE_IMAGE=ruby:${RUBY_IMAGE_VERSION}-slim-buster
FROM ${BASE_IMAGE}

ENV LANG=C.UTF-8

RUN echo "Building base image: $BASE_IMAGE"

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

# ENV vars that danger cares about and base GitHub ENV vars
# https://docs.github.com/en/free-pro-team@latest/actions/reference/environment-variables
ENV GITHUB_TOKEN ""
ENV CI ""
ENV GITHUB_ACTION ""
ENV GITHUB_ACTIONS ""
ENV GITHUB_ACTOR ""
ENV GITHUB_API_URL ""
ENV GITHUB_BASE_REF ""
ENV GITHUB_EVENT_NAME ""
ENV GITHUB_EVENT_PATH ""
ENV GITHUB_GRAPHQL_URL ""
ENV GITHUB_HEAD_REF ""
ENV GITHUB_REF ""
ENV GITHUB_REPOSITORY ""
ENV GITHUB_RUN_ID ""
ENV GITHUB_RUN_NUMBER ""
ENV GITHUB_SERVER_URL ""
ENV GITHUB_SHA ""
ENV GITHUB_WORKFLOW ""
ENV GITHUB_WORKSPACE ""
