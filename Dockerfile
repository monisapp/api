# The version of Alpine to use for the final image
# This should match the version of Alpine that the `elixir:1.7.2-alpine` image uses
ARG ALPINE_VERSION=3.11

FROM elixir:1.10-alpine AS builder

# The following are build arguments used to change variable parts of the image.
# The name of your application/release (required)
ARG APP_NAME
# The version of the application we are building (required)
ARG APP_VSN
# The environment to build with
ARG MIX_ENV=prod

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

# This copies our app source code into the build container
COPY ./mix.exs .
COPY ./mix.lock .

RUN mix do deps.get, deps.compile

COPY . .

RUN mkdir -p /opt/built && \
    mix do compile, release && \
    cp -r _build/${MIX_ENV}/rel/${APP_NAME}/ /opt/built

FROM alpine:${ALPINE_VERSION}

# The name of your application/release (required)
ARG APP_NAME
ARG MIX_ENV=prod
ARG USER_NAME=app

ENV LANG=C.UTF-8 \
    APP_NAME=${APP_NAME}

RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev && \
    adduser -D ${USER_NAME}

WORKDIR /home/app

COPY --from=builder /opt/built .

RUN chown -R ${USER_NAME}: . && \
    mv ./${APP_NAME} ./app && \
    mv ./app/bin/${APP_NAME} ./app/bin/app

USER ${USER_NAME}

CMD [ "./app/bin/app" , "start" ]
