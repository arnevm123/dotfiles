# AGENTS.md — Neovim Configuration

Personal Neovim configuration written entirely in Lua, using `vim.pack` (native package manager).

## Project Structure

```
init.lua                    # Entry point — sets leader, enables ui2, requires 7 modules
lua/
  pack.lua                  # vim.pack build hook (PackChanged autocmd)
  options.lua               # Global options, netrw, Fd findfunc, grepprg
  filetypes.lua             # Custom filetype detection (gitlab CI, docker-compose)
  keymaps.lua               # Core keymaps + M.map() helper
  autocommand.lua           # Yank highlight, formatoptions, trailing whitespace, cursor restore
  usercommands.lua          # :MarkdownPreviewToggle, :Restart
  statusline.lua            # Custom statusline (diagnostics, git, grapple, unsaved indicators)
  utils.lua                 # Utility library (ripgrep, cspell, URL open, toggles, lint_fix)
  dev.lua                   # prefer_local() helper for local plugin dev
  merge.lua                 # Deep table merge utility
plugin/                     # Plugin specs using vim.pack (auto-sourced by Neovim runtime)
  ai.lua                    #   opencode.nvim (AI agent integration)
  colorscheme.lua           #   seoulbones + devicons + colorizer
  compile-mode.lua          #   compile-mode.nvim + vim-dispatch + baleia
  completion.lua            #   blink.cmp + friendly-snippets
  dadbod.lua                #   vim-dadbod + dadbod-ui
  debug.lua                 #   nvim-dap + dap-view + dap-go
  dial.lua                  #   dial.nvim (increment/decrement)
  editing.lua               #   Comment.nvim, treesj, text-case.nvim, atone.nvim
  file-utils.lua            #   vim-fetch, vim-suda, vim-eunuch
  formatting.lua            #   conform.nvim
  git.lua                   #   diffview, neogit, gitsigns, fugitive, codediff
  grapple.lua               #   grapple.nvim (file bookmarks, overrides m/')
  lang-specific.lua         #   lazydev, gopher.nvim, csv.vim, ansible-vim
  linting.lua               #   nvim-lint
  lsp-adjacent.lua          #   none-ls, fidget.nvim, rulebook, wayfinder
  lsp.lua                   #   Mason + mason-tool-installer + nvim-lspconfig + inc-rename
  oil.lua                   #   oil.nvim file browser
  qf.lua                    #   nvim-bqf + quicker.nvim
  snacks.lua                #   snacks.nvim (picker, bigfile, quickfile, git browse)
  test.lua                  #   neotest (Go, Rust, Python, Plenary)
  treesitter.lua            #   nvim-treesitter + context + textobjects + matchup
  yank.lua                  #   yanky.nvim + yankbank-nvim (sqlite persistence)
  zettelkasten.lua          #   zk-nvim
ftplugin/                   # 29 filetype-specific configs (go, lua, rust, python, etc.)
lsp/                        # Per-LSP-server config files (vim.lsp.config style)
queries/go/injections.scm   # Custom treesitter injection queries
snippets/                   # VSCode-format JSON snippet files
spell/                      # Spell checking dictionary
```

## Build / Lint / Test Commands

There is no build system for this config itself. The tools below are what Neovim
uses internally for linting and formatting Lua files in this repo:

### Formatting (Lua)

```sh
# Format a single file
stylua <file.lua>

# Format all Lua files
stylua .
```

Config: `.stylua.toml` — single setting: `collapse_simple_statement = "Always"`.
StyLua defaults apply: tabs for indentation, 120-char line width.

### Linting (Lua)

```sh
# Lint a single file
selene <file.lua>

# Lint all Lua files
selene .
```

Config: `selene.toml` — `std="lua51+vim"`, allows `mixed_table`, declares `Snacks` as global.
Standard library definition: `vim.toml` (`[vim] any = true`).

### Testing

No automated test suite exists for this config. Changes should be validated by
opening Neovim and verifying the affected functionality works.

For projects **edited within** this Neovim (not this config itself):
- `:Make` runs `b:dispatch` (e.g. `go test ./...` for Go files)
- `compile-mode.nvim` binds `<leader>bu` (build), `<leader>bt` (test), `<leader>bl` (lint), `<leader>br` (run) — all invoke `make <target>`
- `neotest` provides per-test/file/suite runners for Go, Rust, Python, Plenary

## Code Style Guidelines

### Language and Runtime

- **Lua 5.1** targeting Neovim's built-in LuaJIT runtime.
- Use `vim.*` APIs (vim.api, vim.fn, vim.cmd, vim.keymap, vim.lsp, vim.diagnostic, etc.).

### Indentation and Formatting

- **Tabs, not spaces.** `expandtab = false`, `tabstop = 4`, `shiftwidth = 4`.
- Line width: **120 characters** (StyLua default).
- StyLua `collapse_simple_statement = "Always"` — single-statement blocks go on one line:
  ```lua
  if cond then return end
  if not x then return nil end
  for _, v in ipairs(t) do count = count + 1 end
  ```
- Always run `stylua` before committing Lua changes.

### Module Patterns

- **Utility/library modules** (`lua/*.lua`) use the `local M = {} ... return M` pattern:
  ```lua
  local M = {}
  function M.my_function() ... end
  return M
  ```
- **Plugin spec files** (`plugin/*.lua`) call `vim.pack.add({...})` then `require("plugin").setup({...})`:
  ```lua
  vim.pack.add({ "author/plugin-name" })
  require("plugin-name").setup({ ... })
  ```
- **LSP server configs** (`lsp/*.lua`) return a `vim.lsp.Config` table.
- **ftplugin files** set buffer-local options directly (no module wrapper).

### Imports and Requires

- Cross-module: `require("utils")`, `require("keymaps")` (flat in `lua/`, no subdirectory paths).
- External plugins: `require("plugin-name")` — typically right after `vim.pack.add()`.
- Keymap helper: `local map = require("keymaps").map`.
- Use `pcall(require, "module")` for optional dependencies.
- Never use `module()` or global assignments for modules (except the `Fd` function in options.lua).

### Naming Conventions

- **Files**: lowercase, hyphen-separated (`lang-specific.lua`, `lsp-adjacent.lua`).
- **Directories**: lowercase, no hyphens (`plugin/`, `ftplugin/`, `lsp/`).
- **Functions on M (public)**: snake_case (`M.git_cwd`, `M.grep_string`, `M.fzf_fd`).
- **Local/private functions**: snake_case (`get_git_branch`, `can_lsp_rename`).
- **Variables**: snake_case (`file_pattern`, `search_string`).

### Keymap Conventions

- Leader key: `<Space>` (both leader and localleader).
- Keymap helper: `require("keymaps").map(mode, lhs, rhs, desc, extra)` — all keymaps require a `desc`.
- Leader prefix groupings: `f*` (find/picker), `l*` (LSP), `t*` (test), `d*` (debug), `b*` (build/buffers), `g*` (git), `r*` (ripgrep/replace), `a*` (AI), `e*` (editing/Go), `q*` (database), `x*` (clipboard), `G*` (Go OS/diffview), `T*` (tabs), `yo*` (toggles).
- Plugin keymaps are defined in the same `plugin/*.lua` file as the plugin spec.

### Error Handling

- Use `pcall` for optional features and graceful degradation.
- Guard with early returns: `if not x then return end`.
- User-facing messages: `vim.notify(msg, level)` (not `print()`).
- Suppress diagnostics selectively: `---@diagnostic disable-next-line: reason`.

### Type Annotations

- Use LuaLS annotations where helpful: `---@param`, `---@return`, `---@class`, `---@type`.
- Not required exhaustively — use them for utility functions, complex opts tables, and public APIs.

### Plugin Management

- Package manager: **`vim.pack`** (Neovim's native package manager).
- Plugin specs live in `plugin/` and are auto-sourced by Neovim's runtime.
- Plugins are loaded eagerly (no lazy-loading triggers).
- `pack.lua` defines a `PackChanged` autocmd for build hooks on install/update.
- LSP servers / formatters / linters installed via **Mason** (`mason.nvim` + `mason-tool-installer`).
- Two LSP servers are manually installed (not via Mason): `gopls`, `rust_analyzer`.

### Things to Avoid

- Do not use `vim.cmd` for things that have Lua API equivalents.
- Do not add global variables (the `Fd` function in options.lua is a rare exception for `vim.opt.findfunc`).
- Do not use spaces for indentation — this project uses tabs.
- Do not hardcode paths — use `vim.fn.stdpath()`, `vim.fn.getcwd()`, `vim.uv.cwd()`.
- Do not add emoji to code or comments.

### External Tool Config Paths (referenced by this config)

- cspell: `~/.config/linters/cspell.json`, `~/.config/linters/allowed-words`
- golangci-lint: `~/.config/linters/golangci.yaml`
- commitlint: `{git_root}/pyproject.toml`
- DB connections: `.db_connections/` (gitignored)
