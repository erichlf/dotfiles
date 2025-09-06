return {
  "saghen/blink.cmp",
  build = "cargo +nightly build --release",
  dependencies = {
    {
      "giuxtaposition/blink-cmp-copilot",
    },
  },
  opts = function(_, opts)
    opts.fuzzy = {
      implementation = "lua",
    }
    opts.sources = opts.sources or {}
    opts.sources.default = { "lsp", "path", "snippets", "buffer", "copilot" }
    opts.sources.providers = opts.sources.providers or {}
    opts.sources.providers.copilot = opts.sources.providers.copilot or {}

    opts.sources.providers.copilot = {
      name = "copilot",
      module = "blink-cmp-copilot",
      score_offset = 100,
      async = true,
      transform_items = function(_, items)
        local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
        local kind_idx = #CompletionItemKind + 1
        CompletionItemKind[kind_idx] = "Copilot"
        for _, item in ipairs(items) do
          item.kind = kind_idx
        end
        return items
      end,
    }

    -- opts.sources.compat = opts.sources.compat or {}
    -- table.insert(opts.sources.compat, "copilot")

    -- Configure completion behavior
    opts.completion = opts.completion or {}
    opts.completion.accept = opts.completion.accept or {}
    opts.completion.accept.auto_brackets = { enabled = true }

    opts.keymap = opts.keymap or {}
    opts.keymap.preset = "default"
    opts.keymap["<Tab>"] = { "select_next", "snippet_forward", "fallback" }
    opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }
    opts.keymap["<C-Space>"] = { "accept", "fallback" }

    opts.appearance = opts.appearance or {}
    opts.appearance = {
      -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
      kind_icons = {
        Copilot = "",
        Text = "󰉿",
        Method = "󰊕",
        Function = "󰊕",
        Constructor = "󰒓",

        Field = "󰜢",
        Variable = "󰆦",
        Property = "󰖷",

        Class = "󱡠",
        Interface = "󱡠",
        Struct = "󱡠",
        Module = "󰅩",

        Unit = "󰪚",
        Value = "󰦨",
        Enum = "󰦨",
        EnumMember = "󰦨",

        Keyword = "󰻾",
        Constant = "󰏿",

        Snippet = "󱄽",
        Color = "󰏘",
        File = "󰈔",
        Reference = "󰬲",
        Folder = "󰉋",
        Event = "󱐋",
        Operator = "󰪚",
        TypeParameter = "󰬛",
      },
    }

    return opts
  end,
}
