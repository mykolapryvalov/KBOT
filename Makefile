APP := $(shell basename $(shell git remote get-url origin) | tr '[:upper:]' '[:lower:]')
REGISTRY=mykolapryvalov
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

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

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	docker tag ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} ${REGISTRY}/${APP}:latest

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot	