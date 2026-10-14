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
echo "Updating dlv"
go install github.com/go-delve/delve/cmd/dlv@latest
echo "Updating govulncheck"
go install golang.org/x/vuln/cmd/govulncheck@latest
echo "Updating mockery"
go install github.com/vektra/mockery/v3@latest
echo "Updating yq"
go install github.com/mikefarah/yq/v4@latest
echo "Updating revive"
go install github.com/mgechev/revive@latest
echo "Updating oapi-codegen"
go install github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest
echo "Updating ogen"
go install github.com/ogen-go/ogen/cmd/ogen@latest
echo "Updating golines"
go install github.com/golangci/golines@latest
echo "Updating gotest"
go install codeberg.org/marcelloh/gotest@latest
echo "Updating benchstat"
go install golang.org/x/perf/cmd/benchstat@latest
echo "Updating go-mod-outdated"
go install github.com/psampaz/go-mod-outdated@latest
echo "Updating act"
go install github.com/nektos/act@latest
echo "Updating asdf"
go install github.com/asdf-vm/asdf/cmd/asdf@latest
echo "Updating godig"
go install github.com/samber/godig/cmd/godig@latest
echo "Updating godoc-mcp"
go install github.com/mrjoshuak/godoc-mcp@latest
echo "Updating mcp-dap-server"
go install github.com/go-delve/mcp-dap-server@latest
echo "Updating zk"
go install github.com/zk-org/zk@latest
echo "Updating epuppy"
go install codeberg.org/scip/epuppy@latest
echo "Updating matcha"
go install github.com/floatpane/matcha@latest
echo "Updating rice"
go install github.com/GeertJohan/go.rice/rice@latest
