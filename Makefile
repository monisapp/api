.PHONY: help

PWD ?= `pwd`
DOCKERHUB_ORG ?= "monisapp"
APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
	BUILD ?= `git rev-parse --short HEAD`
	DIRTY ?= `[[ -z "$(shell git status -s)" ]] || echo '-dirty'`

ELIXIR_IMAGE ?= `grep 'FROM elixir:' Dockerfile | cut -d' ' -f2`

help: ## Show help
	@echo "$(APP_NAME):$(APP_VSN)-$(BUILD)$(DIRTY)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dev: ## Run development environment
	docker-compose up

build: ## Build the Docker image
	docker build --build-arg APP_NAME=$(APP_NAME) \
		--build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		-t $(DOCKERHUB_ORG)/$(APP_NAME):$(APP_VSN)$(DIRTY) \
		-t $(DOCKERHUB_ORG)/$(APP_NAME):$(APP_VSN)-$(BUILD)$(DIRTY) \
		-t $(DOCKERHUB_ORG)/$(APP_NAME):latest .

lint: ## Runs linting locally
	mix credo --config-file ./config/.credo.exs --strict

test: config/ lib/ priv/ test/ ## Runs tests locally
	docker-compose up -d postgres
	@sleep 5s
	mix test
	docker-compose down

docker_push: build ## Pushes built image to registry
	docker push $(DOCKERHUB_ORG)/$(APP_NAME):$(APP_VSN)$(DIRTY)
	docker push $(DOCKERHUB_ORG)/$(APP_NAME):$(APP_VSN)-$(BUILD)$(DIRTY)
	docker push $(DOCKERHUB_ORG)/$(APP_NAME):latest

run: ## Run the app in Docker
	docker run --env-file config/docker.env \
		--expose 4000 -p 4000:4000 \
		--rm -it $(APP_NAME):latest
