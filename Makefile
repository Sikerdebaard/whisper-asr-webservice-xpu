#!make
include .env
GIT_HASH ?= $(shell git log --format="%h" -n 1)

build:
	docker build -f Dockerfile.arc-xpu --tag ${DOCKER_USERNAME}/${APPLICATION_NAME} .

run:
	docker run --rm --device ${DRIDEVICE}:/dev/dri -e ASR_MODEL=large -e ASR_ENGINE=openai_whisper -p 9000:9000 ${DOCKER_USERNAME}/${APPLICATION_NAME}

push:
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}

release:
	docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}
	docker tag  ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH} ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
	docker push ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
