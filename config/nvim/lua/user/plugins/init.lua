return {
  { "hrsh7th/cmp-buffer", lazy = true },
  { "hrsh7th/cmp-cmdline", lazy = true },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-path", lazy = true },
  { "saadparwaiz1/cmp_luasnip", lazy = true },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" }, -- lines for indent level
  { "nvim-lua/plenary.nvim", cmd = { "PenaryBustedFile", "PlenaryBustedDirectory" }, lazy = true }, -- lua functions that many plugins use
  { "tpope/vim-fugitive", lazy = true }, -- git plugin so good it should be illegal
  { "christoomey/vim-tmux-navigator", lazy = true }, -- tmux & split window navigation
}
