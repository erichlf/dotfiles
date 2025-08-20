return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  opts = function(_, opts)
    opts.sources = opts.sources or {}
    opts.sources.compat = opts.sources.compat or {}
    table.insert(opts.sources.compat, "copilot")

    -- Configure completion behavior
    opts.completion = opts.completion or {}
    opts.completion.accept = opts.completion.accept or {}
    opts.completion.accept.auto_brackets = { enabled = true }

    opts.keymap = opts.keymap or {}
    opts.keymap.preset = "default"
    opts.keymap["<Tab>"] = { "select_next", "snippet_forward", "fallback" }
    opts.keymap["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }
    opts.keymap["<C-Space>"] = { "accept", "fallback" }

    return opts
  end,
}
