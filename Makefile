DOCKER_REGISTRY ?= docker.io
DOCKER_USER_GROUP ?= lnlscon
DOCKER_IMAGE_PREFIX = $(DOCKER_REGISTRY)/$(DOCKER_USER_GROUP)

DATE = $(shell date -I)

DOCKER_TAG = master-$(DATE)
DOCKER_IMAGE = $(DOCKER_IMAGE_PREFIX)/olog-server

build:
	docker build \
		--label br.com.lnls-sirius.docker-repo=https://github.com/lnls-sirius/docker-olog-server\
		--label br.com.lnls-sirius.repo=https://gitlab.cnpem.br/con/olog-web-client\
		--label br.com.lnls-sirius.maintener=claudio.carneiro\
		--label br.com.lnls-sirius.group=GAS\
		--tag $(DOCKER_IMAGE):$(DOCKER_TAG) .

push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG) .
