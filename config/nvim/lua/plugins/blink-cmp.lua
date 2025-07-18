return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  opts = function(_, opts)
    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next" },
      ["<S-Tab>"] = { "select_prev" },
      ["<CR>"] = { "accept" },
    }
    return opts
  end,
}
