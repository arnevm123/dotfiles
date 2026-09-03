require("xeno").setup({
  background = "#1A120B",
  accent = "#EADBC8",
  properties = {
    contrast = 0.1,
    variation = 0.1,
    chroma = 0.1,
    lightness = 0.0,
  },
  transparent = true,
  foreground = "#F5EFE6",
  _custom_colors = {
    latte = "#D8B395",
    matcha = "#A3B18A",
    chai = "#E9C46A",
    caramel = "#E6A15C",
    cream = "#F1E3D3",
    cinnamon = "#CD6A53",
    mocha = "#A08066"
  },
  decorations = {
    borders = true
  },
  highlights = {
    plugins = {
      ["ibhagwan/fzf-lua"] = {}
    },
    editor = {
      CursorLineNr = {
        fg = "@accent.200",
        bold = true
      },
      LineNr = {
        fg = "@background.500"
      },
      MatchParen = {
        fg = "@caramel.200",
        underline = true,
        bold = true
      },
      Visual = {
        bg = {
          fg = "@accent.500",
          opacity = 0.18,
          __xeno_opaque = true
        }
      },
      CursorLine = {
        bg = {
          fg = "@background.600",
          opacity = 0.05,
          __xeno_opaque = true
        }
      },
      Normal = {
        fg = "@foreground.200"
      }
    },
    syntax = {
      ["@string.regex"] = {
        fg = "@cinnamon.200"
      },
      ["@string.escape"] = {
        fg = "@chai.200"
      },
      ["@number"] = {
        link = "Number"
      },
      ["@boolean"] = {
        link = "Boolean"
      },
      ["@variable"] = {
        link = "Variable"
      },
      ["@variable.builtin"] = {
        fg = "@cinnamon.200"
      },
      ["@variable.parameter"] = {
        fg = "@foreground.100"
      },
      ["@property"] = {
        link = "Property"
      },
      ["@operator"] = {
        link = "Operator"
      },
      Type = {
        fg = "@matcha.300"
      },
      ["@punctuation.bracket"] = {
        link = "Punctuation"
      },
      ["@punctuation.delimiter"] = {
        link = "Punctuation"
      },
      ["@lsp.type.variable"] = {
        link = "@variable"
      },
      ["@lsp.type.function"] = {
        link = "@function"
      },
      ["@lsp.type.method"] = {
        link = "@function.method"
      },
      ["@lsp.type.type"] = {
        link = "@type"
      },
      ["@lsp.type.keyword"] = {
        link = "@keyword"
      },
      ["@lsp.type.parameter"] = {
        link = "@variable.parameter"
      },
      Function = {
        fg = "@cream.200"
      },
      Variable = {
        fg = "@foreground.200"
      },
      Property = {
        fg = "@mocha.200"
      },
      ["@lsp.type.property"] = {
        link = "@property"
      },
      Keyword = {
        fg = "@caramel.300"
      },
      String = {
        fg = "@latte.300"
      },
      Number = {
        fg = "@chai.200"
      },
      Boolean = {
        fg = "@chai.200"
      },
      Conditional = {
        fg = "@cinnamon.300"
      },
      ["@punctuation"] = {
        link = "Punctuation"
      },
      ["@keyword"] = {
        link = "Keyword"
      },
      ["@keyword.function"] = {
        link = "Keyword"
      },
      ["@keyword.return"] = {
        link = "Conditional"
      },
      ["@keyword.conditional"] = {
        link = "Conditional"
      },
      ["@keyword.repeat"] = {
        link = "Conditional"
      },
      ["@keyword.operator"] = {
        link = "Operator"
      },
      ["@string"] = {
        link = "String"
      },
      ["@keyword.import"] = {
        fg = "@cinnamon.200"
      },
      ["@function"] = {
        link = "Function"
      },
      ["@function.builtin"] = {
        fg = "@accent.200"
      },
      ["@function.method"] = {
        link = "Function"
      },
      Comment = {
        fg = "@foreground.400",
        italic = true
      },
      ["@type"] = {
        link = "Type"
      },
      ["@type.builtin"] = {
        fg = "@matcha.200"
      },
      ["@function.macro"] = {
        fg = "@caramel.200"
      },
      ["@type.definition"] = {
        link = "Type"
      }
    }
  },
  integrations = {
    ghostty = {
      enabled = true,
      update_config = true
    }
  },
})
vim.g.colors_name = "latte-express"
