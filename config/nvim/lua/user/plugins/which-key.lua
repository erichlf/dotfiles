return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    mappings = {
      ["/"] = { name = "+Search "}, -- searching
      ["b"] = { name = "+Buffers "}, -- buffer operations
      ["D"] = { name = "+Devcontainer " }, -- devcontainer operations
      ["e"] = { name = "+Explorer " }, -- file operations
      ["f"] = { name = "+Files " }, -- file operations
      ["g"] = { name = "+Git " }, -- git operations
      ["p"] = { name = "+Projects" }, -- project/workspace operations
      ["q"] = { name = "+Quit " }, -- quiting
      ["t"] = { name = "+TODO " }, -- devcontainer operations
      ["T"] = { name = "+Trouble " }, -- devcontainer operations
      ["w"] = { name = "+Windows " }, -- split window operations
    }

    require("which-key").register(mappings, { prefix = "<leader>" })
  end,
  opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  },
  vopts = {
    mode = "v", -- VISUAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  },
}
