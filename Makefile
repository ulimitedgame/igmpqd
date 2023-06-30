GITCOMMIT?=$(shell git rev-parse HEAD)
GITDESCRIBE?=$(shell git describe --tags 2>/dev/null || echo nightly)
BUILD_EPOCH?=$(shell date +%s)

GO_MODULE=github.com/ulimitedgame/go-igmpqd
GO_MODULE_DEPS=go.mod go.sum

BUILD_ARCHS=386 amd64 arm
BUILD_OS=linux darwin windows

BUILD_ARCHS=386 amd64 
BUILD_OS=linux


#go install github.com/mitchellh/gox@latest
all: $(GO_MODULE_DEPS)
	gox -arch="$(BUILD_ARCHS)" -os="$(BUILD_OS)" \
	-ldflags="-X main.GitCommit=$(GITCOMMIT) -X main.GitDescribe=$(GITDESCRIBE) -X main.BuildTime=$(BUILD_EPOCH)" \
	-output="bin/{{.OS}}/{{.Arch}}/{{.Dir}}"

	/bin/bash ./build-release-bins.sh

go.sum: go.mod
	go mod tidy

go.mod:
	go mod init $G(O_MODULE)

clean:
	rm -rf bin

ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "info"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif

run: 
	@echo "ARGS=$(RUN_ARGS)"
	sudo bin/linux/amd64/go-igmpqd $(RUN_ARGS)

.PHONY: all clean run

