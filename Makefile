DOCKER_REGISTRY ?= docker.io
DOCKER_USER_GROUP ?= lnlscon
DOCKER_IMAGE_PREFIX = $(DOCKER_REGISTRY)/$(DOCKER_USER_GROUP)

DATE = $(shell date -I)

OLOG_WEB_HASH=bc375e1
OLOG_WEB_REPO=https://github.com/lnls-sirius/olog-web-client

DOCKER_TAG = $(OLOG_WEB_HASH)-$(DATE)
DOCKER_IMAGE = $(DOCKER_IMAGE_PREFIX)/olog-server

build:
	docker build \
		--build-arg OLOG_WEB_REPO=$(OLOG_WEB_REPO)\
		--build-arg OLOG_WEB_HASH=$(OLOG_WEB_HASH)\
		--label br.com.lnls-sirius.docker-repo=https://github.com/lnls-sirius/docker-olog-server\
		--label br.com.lnls-sirius.repo=$(OLOG_WEB_REPO)\
		--label br.com.lnls-sirius.commit=$(OLOG_WEB_HASH)\
		--label br.com.lnls-sirius.maintener=claudio.carneiro\
		--label br.com.lnls-sirius.group=GAS\
		--tag $(DOCKER_IMAGE):$(DOCKER_TAG) .

push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
