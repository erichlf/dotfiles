return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local keys = opts.dashboard.preset.keys
      opts.dashboard.preset.keys[#keys + 1] = {
        action = "<CMD>lua require('devcontainer-cli.devcontainer_cli').up()<CR>",
        desc = "Bringup Devcontainer",
        icon = LazyVim.config.icons.kinds.Package,
        key = "D",
      }

      return opts
    end,
  },
}
