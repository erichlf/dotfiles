return {
  "saghen/blink.cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next" },
      ["<S-Tab>"] = { "select_prev" },
      ["<CR>]"] = { "accept" },
    },
  },
}
