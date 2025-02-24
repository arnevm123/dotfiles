#!/usr/bin/env bash

if [ -z "$1" ]; then
	json=$(curl -s "https://go.dev/dl/?mode=json")
	latest_go_version=$(echo "$json" | jq -r '.[0].version' | sed 's/go//')
	GO_VERSION="$latest_go_version"
else
	GO_VERSION="$1"
fi

curl -O https://dl.google.com/go/go"$GO_VERSION".linux-amd64.tar.gz
rm -rf "$GOROOT" || true
tar -C "$HOME" -xzf go"$GO_VERSION".linux-amd64.tar.gz
rm -f ~/bin/go"$GO_VERSION".linux-amd64.tar.gz
