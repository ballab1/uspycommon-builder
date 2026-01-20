ARG FROM_BASE="${FROM_BASE:-${DOCKER_REGISTRY}docker.io/python:3.13.2-alpine3.21}"
FROM $FROM_BASE

LABEL Maintainers="bobb@k8s.home"
LABEL Version="1.0"
LABEL Description="builder environment for python containers"

# Set the environments
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


RUN apk update \
    && apk add --no-cache git jq libffi-dev gcc musl-dev librdkafka-dev

ARG HOME_DIR=/app
ARG USER_ID=1000
ARG GROUP=users

WORKDIR /usr/src
COPY requirements.txt .

RUN set -x \
   && adduser -h "$HOME_DIR" -s /bin/sh -G "$GROUP" -D -u "$USER_ID" builder \
   && python -m pip install --no-cache-dir -r requirements.txt \
   && export PATH=$PATH:$HOME_DIR

USER builder
WORKDIR "$HOME_DIR"

CMD [ 'python' ]