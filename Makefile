APP := $(shell basename $(shell git remote get-url origin) | tr '[:upper:]' '[:lower:]')
REGISTRY := ghcr.io/mykolapryvalov
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

format:
	gofmt -s -w ./

get:
	go get	

lint:
	golint

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/mykolapryvalov/kbot/cmd.appVersion=${VERSION}

echo-version:
	echo ${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}
	docker tag ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} ${REGISTRY}/${APP}:latest

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot	

linux:
	GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X=github.com/mykolapryvalov/kbot/cmd.appVersion=${VERSION}"

arm:
	GOOS=linux GOARCH=arm64 go build -v -o kbot -ldflags "-X=github.com/mykolapryvalov/kbot/cmd.appVersion=${VERSION}"

macos:
	GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X=github.com/mykolapryvalov/kbot/cmd.appVersion=${VERSION}"

windows:
	GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X=github.com/AnnaHurtovenko/kbot/cmd.appVersion=${VERSION}"
