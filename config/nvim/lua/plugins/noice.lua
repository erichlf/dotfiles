return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.presets.bottom_search = false

      return opts
    end,
  },
}
