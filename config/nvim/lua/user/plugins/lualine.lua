return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("user.core.lualine").setup()
  end,
  event = "VimEnter"
}
