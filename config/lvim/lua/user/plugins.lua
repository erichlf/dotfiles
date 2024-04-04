-- lvim.builtin.autopairs.active = true
-- lvim.builtin.telescope = true

-- Additional Plugins
lvim.plugins = 
{
-- General
  { -- auto complete tags
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").init()
    end,
  },
  { "mrjones2014/nvim-ts-rainbow", }, -- rainbow brackets
  { -- project tracking
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    init = function()
      vim.cmd [[packadd telescope.nvim]]
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      -- { "<m-Left>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      -- { "<m-Down>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      -- { "<m-Up>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      -- { "<m-Right>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      -- { "<m-Tab>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      -- { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

-- workflows
  -- {
  --   'harrisoncramer/gitlab.nvim',
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "sindrets/diffview.nvim",
  --     "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
  --     "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
  --   },
  --   run = function() require("gitlab.server").build(true) end,
  --   config = function()
  --     require("gitlab").setup()
  --   end,
  -- },

-- C++
  {"p00f/clangd_extensions.nvim"},
-- python
  {"stevearc/dressing.nvim"},
  {"nvim-neotest/neotest"},
  {"nvim-neotest/neotest-python"},
  {"mfussenegger/nvim-dap-python"},
  {"ChristianChiarulli/swenv.nvim"},
-- Devcontainers
  {
    "arnaupv/nvim-devcontainer-cli",
    opts = {
      -- By default, if no extra config is added, following nvim_dotfiles are
      -- installed: "https://github.com/LazyVim/starter"
      -- This is an example for configuring other nvim_dotfiles inside the docker container
      nvim_dotfiles_repo = "https://github.com/arnaupv/dotfiles.git",
      nvim_dotfiles_install_command = "cd ~/nvim_dotfiles/ && ./install.sh",
      -- In case you want to change the way the devenvironment is setup, you can also provide your own setup
      setup_environment_repo = "https://github.com/arnaupv/setup-environment",
      setup_environment_install_command = "./install.sh -p 'nvim stow zsh'",
    },
    keys = {
      -- stylua: ignore
      {
        "<leader>Du",
        ":DevcontainerUp<cr>",
        desc = "Up the DevContainer",
      },
      {
        "<leader>Dc",
        ":DevcontainerConnect<cr>",
        desc = "Connect to DevContainer",
      },
    }
  },
}

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    local ok, cmp = pcall(require, "copilot_cmp")
    if ok then cmp.setup({}) end
  end,
})
