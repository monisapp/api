FROM elixir:latest

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    mix local.hex --force && \
    mix do compile

CMD [ "bash", "-c", "/app/entrypoint.sh"]
