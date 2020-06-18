# ----- Docker -----

DOCKER_CONTAINER_NAME=elasticsearch
DOCKER_REPOSITORY=$(DOCKER_USERNAME)/$(DOCKER_CONTAINER_NAME)
DOCKER_PLATFORMS=linux/amd64,linux/arm64

docker-image-local:
	docker build --rm -t $(DOCKER_REPOSITORY):local .

ci-docker-auth:
	@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)

ci-docker-build: ci-docker-auth
	@docker build --no-cache -t $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) .

ci-docker-push: ci-docker-auth
	docker tag $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) $(DOCKER_REPOSITORY):latest
	docker push $(DOCKER_REPOSITORY)

ci-docker-buildx: ci-docker-auth
	@docker buildx build \
		-t $(DOCKER_REPOSITORY):$(GITHUB_SHA::8) $(DOCKER_REPOSITORY):latest \
		--platform ${DOCKER_PLATFORMS} \
		--output "type=image,push=true" .
