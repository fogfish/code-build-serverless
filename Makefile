.PHONY: all build test publish clean

APP ?= serverless
ORG ?= code-build
HUB ?=

IID   = $(if $(HUB), ${HUB}/${ORG}/${APP}, ${ORG}/${APP}) 
LOCAL = ${ORG}/${APP}
TEST  = ${ORG}/${APP}:test
REPO  = ${ORG}/${APP}

all: build test publish

build:
	@docker build -t ${IID} .
	@docker tag ${IID} ${LOCAL}

clean:
	-@docker rmi -f ${LOCAL}
	-@docker rmi -f ${IID}

test:
	@docker build -t ${TEST} test
	@docker run --rm --privileged ${TEST}
	@docker rmi ${TEST}

publish:
	@REPO=${REPO} cdk deploy
	@eval $(shell aws ecr get-login --no-include-email --region eu-west-1)
	@docker push ${IID}
