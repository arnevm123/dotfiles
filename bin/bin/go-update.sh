#!/usr/bin/env bash

echo "Updating Go"
~/bin/install-go.sh

echo "Updating golangci-lint"
~/bin/install-golangci.sh

echo "Updating Go tools..."

echo "Updating wgo"
go install github.com/bokwoon95/wgo@latest
echo "Updating iferr"
go install github.com/koron/iferr@latest
echo "Updating gofumpt"
go install mvdan.cc/gofumpt@latest
echo "Updating deadcode"
go install golang.org/x/tools/cmd/deadcode@latest
echo "Updating gotestsum"
go install gotest.tools/gotestsum@latest
echo "Updating air"
go install github.com/air-verse/air@latest
echo "Updating grove"
go install github.com/sqve/grove/cmd/grove@latest
