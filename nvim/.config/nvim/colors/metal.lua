require("xeno").setup({
  background = "#2b2d2e",
  accent = "#c17a3d",
  properties = {
    contrast = -0.1,
    variation = 0.0,
    chroma = -0.1,
    lightness = -0.1,
  },
  transparent = true,
  foreground = "#c6cac7",
  _custom_colors = {
    amber = "#c99a3f",
    brick = "#a4453c",
    moss = "#8a9463",
    umber = "#7a5c42",
    rust = "#b5622f",
    olive = "#6f7a4a"
  },
  decorations = {
    borders = true
  },
  highlights = {
    editor = {
      CursorLineNr = {
        fg = "@amber.100",
        bold = true
      },
      MatchParen = {
        fg = "@brick.100",
        bold = true
      }
    },
    syntax = {
      Punctuation = {
        fg = "@foreground.400"
      },
      Comment = {
        fg = "@foreground.400",
        italic = true
      },
      ["@keyword.return"] = {
        link = "Keyword"
      },
      ["@keyword.function"] = {
        link = "Conditional"
      },
      ["@keyword.conditional"] = {
        link = "Conditional"
      },
      ["@keyword.repeat"] = {
        link = "Conditional"
      },
      ["@keyword.operator"] = {
        fg = "@rust.300"
      },
      ["@keyword.import"] = {
        fg = "@umber.400"
      },
      ["@function"] = {
        link = "Function"
      },
      ["@function.builtin"] = {
        fg = "@amber.100"
      },
      ["@type"] = {
        link = "Type"
      },
      ["@string.escape"] = {
        fg = "@amber.100"
      },
      ["@number"] = {
        link = "Number"
      },
      ["@boolean"] = {
        link = "Boolean"
      },
      ["@constant"] = {
        fg = "@amber.100"
      },
      ["@constant.builtin"] = {
        fg = "@amber.100",
        bold = true
      },
      ["@variable"] = {
        link = "Variable"
      },
      ["@variable.builtin"] = {
        fg = "@brick.200"
      },
      ["@property"] = {
        link = "Property"
      },
      ["@constructor"] = {
        fg = "@foreground.400"
      },
      ["@lsp.type.variable"] = {
        link = "@variable"
      },
      ["@lsp.mod.declaration"] = {
        clear = true
      },
      Function = {
        fg = "@amber.300"
      },
      ["@punctuation"] = {
        link = "Punctuation"
      },
      ["@punctuation.bracket"] = {
        link = "Punctuation"
      },
      Variable = {
        fg = "@foreground.300"
      },
      Property = {
        fg = "@moss.300"
      },
      Keyword = {
        fg = "@umber.300"
      },
      ["@lsp.type.property"] = {
        link = "@property"
      },
      Operator = {
        fg = "@rust.300"
      },
      ["@operator"] = {
        link = "Operator"
      },
      ["@punctuation.delimiter"] = {
        link = "Punctuation"
      },
      Conditional = {
        fg = "@brick.300"
      },
      ["@keyword"] = {
        link = "Keyword"
      },
      String = {
        fg = "@olive.100"
      },
      Number = {
        fg = "@amber.100"
      },
      Boolean = {
        fg = "@amber.100"
      },
      ["@string"] = {
        link = "String"
      },
      Type = {
        fg = "@rust.200"
      }
    },
    plugins = {
      ["ibhagwan/fzf-lua"] = {}
    }
  },
  integrations = {
    ghostty = {
      enabled = true,
      update_config = true
    }
  },
})
vim.g.colors_name = "metal"
