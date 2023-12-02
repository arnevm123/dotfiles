#!/usr/bin/env bash

if [ -z "$1" ]; then
	# If no argument is provided, use the latest Go version
	GOLANGCI_VERSION="latest"
else
	# If an argument is provided, use that version
	GOLANGCI_VERSION="$1"
fi

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh |
	sh -s -- -b "$GOPATH"/bin "$GOLANGCI_VERSION"
