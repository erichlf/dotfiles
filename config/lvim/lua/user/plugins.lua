lvim.plugins = {
  -- auto complete tags
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").init()
    end,
  },

  -- github co-pilot
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      local ok, cmp = pcall(require, "copilot_cmp")
      if ok then cmp.setup({}) end
    end,
  },

  {
    "erichlf/devcontainer-cli.nvim",
    -- dir = "/home/elfoster/workspace/devcontainer-cli.nvim",
    -- dev = true,
    -- branch = "AddShell",
    opts = {
      interactive = false,
      dotfiles_repository = "https://github.com/erichlf/dotfiles.git",
      dotfiles_branch = "devcontainer",
      dotfiles_targetPath = "~/dotfiles",
      dotfiles_installCommand = "install.sh",
      shell = "zsh",
    },
    keys = {
      -- stylua: ignore
      {
        "<leader>Du",
        "<CMD>DevcontainerUp<CR>",
        desc = "Bring Up the DevContainer",
      },
      {
        "<leader>De",
        "<CMD>DevcontainerExec<CR>",
        desc = "Execute a command in the DevContainer",
      },
      {
        "<leader>Db",
        "<CMD>DevcontainerExec colcon build --symlink-install --merge-install<CR>",
        desc = "ROS2 build in the DevContainer",
      },
      {
        "<leader>Dt",
        "<CMD>DevcontainerExec source install/setup.zsh && colcon test --merge-install<CR>",
        desc = "ROS2 test in the DevContainer",
      },
      {
        "<leader>Dc",
        "<CMD>DevcontainerConnect<CR>",
        desc = "Connect to DevContainer",
      },
    }
  },

  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
      { 'MunifTanjim/nui.nvim' }
    }
  },

  -- git
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gL", "<CMD>LazyGitCurrentFile<CR>", desc = "LazyGit" },
    },
  },

  -- gitlab
  {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "stevearc/dressing.nvim",     -- Recommended but not required. Better UI for pickers.
      "nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
    },
    enabled = true,
    build = function()
      require("gitlab.server").build(true)
    end, -- Builds the Go binary
    config = function()
      require("gitlab").setup()
    end,
  },

  -- images
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  -- interface
  { "stevearc/dressing.nvim" },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- python
  { "nvim-neotest/neotest" },
  { "nvim-neotest/neotest-python" },
  { "mfussenegger/nvim-dap-python" },
  { "ChristianChiarulli/swenv.nvim" },

  -- project tracking
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    -- init = function()
    --   vim.cmd [[packadd telescope.nvim]]
    -- end,
  },

  -- tmux
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
      }
    end
  },

  -- rainbow brackets
  { "mrjones2014/nvim-ts-rainbow", },
}
