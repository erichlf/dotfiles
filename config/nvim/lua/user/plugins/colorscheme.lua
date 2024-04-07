return {
  "lunarvim/lunar.nvim",
  priority = 1000,
  config = function()

    require("lunar").setup({
      style = "night",
    })

    vim.cmd("colorscheme lunar")
  end
}
