# ----- Docker -----

DOCKER_CONTAINER_NAME=elasticsearch
DOCKER_REPOSITORY=$(DOCKER_USERNAME)/$(DOCKER_CONTAINER_NAME)
DOCKER_PLATFORMS=linux/amd64,linux/arm64

docker-image-local:
	docker build --rm -t $(DOCKER_REPOSITORY):local .

ci-docker-auth:
	@echo "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

ci-docker-build:
	@docker build --no-cache -t $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) .

ci-docker-push: ci-docker-build
	docker tag $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) $(DOCKER_REPOSITORY):latest
	docker push $(DOCKER_REPOSITORY)

ci-docker-buildx:
	@docker buildx build --platform ${DOCKER_PLATFORMS} \
		--tag $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) $(DOCKER_REPOSITORY):latest \
		--output "type=image,push=false" .

ci-docker-buildx-push: ci-docker-buildx
	@docker buildx build --platform ${DOCKER_PLATFORMS} \
		--tag $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) $(DOCKER_REPOSITORY):latest \
		--output "type=image,push=true" .
