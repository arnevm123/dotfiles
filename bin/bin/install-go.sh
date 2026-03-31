#!/usr/bin/env bash

if [ -z "$1" ]; then
	json=$(curl -s "https://go.dev/dl/?mode=json")
	GO_VERSION=$(echo "$json" | jq -r '.[0].version' | sed 's/go//')
else
	GO_VERSION="$1"
fi

CURRENT_VERSION=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
if [ "$CURRENT_VERSION" = "$GO_VERSION" ]; then
	echo "go $GO_VERSION is already installed"
	exit 0
fi

echo "updating go $CURRENT_VERSION -> $GO_VERSION"

curl -O https://dl.google.com/go/go"$GO_VERSION".linux-amd64.tar.gz
rm -rf "$GOROOT" || true
tar -C "$HOME" -xzf go"$GO_VERSION".linux-amd64.tar.gz
rm -f ~/bin/go"$GO_VERSION".linux-amd64.tar.gz
