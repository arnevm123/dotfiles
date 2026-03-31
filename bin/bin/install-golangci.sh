#!/usr/bin/env bash

if [ -z "$1" ]; then
	GOLANGCI_VERSION=$(curl -s https://api.github.com/repos/golangci/golangci-lint/releases/latest | jq -r '.tag_name' | sed 's/^v//')
else
	GOLANGCI_VERSION="${1#v}"
fi

CURRENT_VERSION=$(golangci-lint version 2>/dev/null | awk '{print $4}')
if [ "$CURRENT_VERSION" = "$GOLANGCI_VERSION" ]; then
	echo "golangci-lint $GOLANGCI_VERSION is already installed"
	exit 0
fi

echo "updating golangci-lint $CURRENT_VERSION -> $GOLANGCI_VERSION"

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$GOPATH"/bin "v$GOLANGCI_VERSION"
