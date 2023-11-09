GO_VERSION=1.21.0

tools:
	go install github.com/melkeydev/go-blueprint@latest
	go install github.com/bokwoon95/wgo@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

install:
	go install golang.org/dl/go${GO_VERSION}@latest
	go${GO_VERSION} download
	mkdir -p bin
	ln -sf `go env GOPATH`/bin/go${GO_VERSION} bin/go
