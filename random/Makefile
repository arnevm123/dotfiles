LOG_LEVEL?=info
BINARY_NAME=$(shell basename $(shell go list))
VERSION?=development
# TODO: do we set version from git tags?
# VERSION?=$(shell git describe --tags --always --dirty)
COMMIT=$(shell git rev-parse --verify HEAD)
DATE?=$(shell date +%FT%T%z)
RELEASE?=0
GO_LDFLAGS+=-X main.appName=$(BINARY_NAME)
GO_LDFLAGS+=-X main.buildVersion=$(VERSION)
GO_LDFLAGS+=-X main.buildCommit=$(COMMIT)
GO_LDFLAGS+=-X main.buildDate=$(DATE)
ifeq ($(RELEASE), 1)
	# Strip debug information from the binary
	GO_LDFLAGS+=-s -w
endif
GO_LDFLAGS:=-ldflags="$(GO_LDFLAGS)"

.PHONY: all
all: help

.PHONY: build
## build|b: Build the application for the host machine's OS
build b:
	@echo "Building the application for the host machine's OS"
	@# the flags "all=-N -l" allow you to attach to the running process with you debugger
	@go build -gcflags="all=-N -l" ${GO_LDFLAGS} -o ./bin/${BINARY_NAME}

.PHONY: build-linux
## build-linux: Build the application for Linux
build-linux:
	@echo "Building for Linux"
	@GOARCH=amd64 GOOS=linux go build ${GO_LDFLAGS} -o ./bin/${BINARY_NAME}-linux

.PHONY: build-windows
## build-windows: Build the application for Windows
build-windows:
	@echo "Building for Windows"
	@GOARCH=amd64 GOOS=windows go build ${GO_LDFLAGS} -o ./bin/${BINARY_NAME}-windows.exe

.PHONY: run
## run|r: Run the application
run r: build
	@echo "Running the application"
	@./bin/${BINARY_NAME} --config_file=config.yaml

.PHONY: watch
## watch|w: Run the application with a watcher. This will reload every time you make a change to the code.
watch w:
	@echo "Starting a watcher"
	@if command -v wgo > /dev/null; then \
		wgo run -xfile .lint.txt -xdir bin . --log_level=${LOG_LEVEL} --log_directory= "" --config_file=config.yaml ;\
	else \
		echo "wgo not installed; make install-tools to get all tools."; \
		echo "Or install manually: go install github.com/bokwoon95/wgo/cmd/wgo@latest" ;\
	fi

# Alternative that has a web FE: https://github.com/michenriksen/gokiburi
# This will reload every time you make a change to the code.
# Can be useful for development.
.PHONY: watch-test
## watch-test: Test the application with a watcher. This will reload every time you make a change to the code.
watch-test:
	@echo "Starting a watcher"
	@if command -v wgo > /dev/null; then \
		wgo -xfile lint.txt -xdir bin go test ./... ; \
	else \
		echo "wgo not installed; make install-tools to get all tools."; \
		echo "Or install manually: go install github.com/bokwoon95/wgo/cmd/wgo@latest"; \
	fi

.PHONY: clean
## clean: Clean the environment
clean:
	@echo "Cleaning the environment"
	@go clean
	@rm -rf bin/*
	@rm -f .lint.txt

.PHONY: lint
## lint|l: Lint the application and add the output to .lint.txt
lint l:
	@echo "Linting the application"
	@echo "The output will also be in .lint.txt"
	@if command -v golangci-lint > /dev/null; then \
		golangci-lint run --config=./.golangci.yaml | tee .lint.txt ;\
		# GOOS=linux golangci-lint run --config=./.golangci.yaml | tee .lint.txt ;\
		# GOOS=windows golangci-lint run --config=./.golangci.yaml | tee --append .lint.txt ;\
	else \
		echo "golangci-lint not installed; make install-golangci"; \
		echo "https://golangci-lint.run/usage/install/ for more info" ;\
	fi

.PHONY: format
## format|fmt: Run gofumpt and goimports-reviser on the whole application.
format fmt:
	@echo "Formatting the application"
	@go mod tidy
	@if command -v gofumpt > /dev/null; then \
		gofumpt -extra -l -w . ;\
	else \
		echo "gofumpt not installed; make install-tools to get all tools."; \
		echo "Falling back to gofmt, might break the pipeline"; \
		echo "Or install manually: go install mvdan.cc/gofumpt@latest"; \
	    gofmt -l -w . ;\
	fi

	@if command -v goimports-reviser > /dev/null; then \
	    goimports-reviser -rm-unused -project-name=project ./... ;\
	else \
		echo "goimports-reviser not installed; make install-tools to get all tools."; \
		echo "Or install manually: go install -v github.com/incu6us/goimports-reviser/v3@latest" ;\
	fi

.PHONY: test
## test: Test the application
test:
	@echo "Testing the application"
	@go run gotest.tools/gotestsum@latest --format=pkgname-and-test-fails ./... -coverprofile=.coverage.out -covermode count

.PHONY: coverage
## coverage: Generate test coverage report (.coverage.xml and .coverage.out)
coverage: test
	@echo "Generating test coverage report"
	@go tool cover -func .coverage.out
	@go run github.com/boumenot/gocover-cobertura@latest < .coverage.out > .coverage.xml; \

.PHONY: precommit
## precommit|p: Useful to run before committing, or if the pipeline fails. Runs format, lint and test coverage.
precommit: format coverage lint

.PHONY: install-tools
## install-tools: Installs all tools (wgo, gofumpt, gocover-cobertura, goimports-reviser)
install-tools:
	go install github.com/bokwoon95/wgo@latest
	go install mvdan.cc/gofumpt@latest
	go install github.com/t-yuki/gocover-cobertura@latest
	go install -v github.com/incu6us/goimports-reviser/v3@latest


# Separated, because it's not a go install. Their documentation advices against using the go install
# you can also just sudo apt-get install golangci-lint or similar
.PHONY: install-golangci
## install-golangci: Installs golangci-lint
install-golangci:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$GOPATH"/bin latest

# Separated, because it's not a go install.make
# This is our own internal fork
.PHONY: install-gotests
## install-gotests: Installs gotests
install-gotests:
	git clone git@gitlab.telecom-it.be:development/gotests.git && pushd gotests/gotests && go install . && popd && rm -rf gotests

.PHONY: help
## help|h: prints this help message
help h:
	@echo "Usage:"
	@echo ""
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
	@echo ""
	@echo "Advanced usage:"
	@echo ""
	@echo "Add versioning or releases:"
	@echo "make RELEASE=1 VERSION=1.2.3 build-linux"
	@echo "Changing log level (default: info):"
	@echo "make LOG_LEVEL=debug run"

%:
	@echo "Invalid target. Run 'make help' for more information."
