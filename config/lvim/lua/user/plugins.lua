lvim.plugins = {
  -- auto complete tags
  {
    "windwp/nvim-ts-autotag",
    init = function()
      require("nvim-ts-autotag").init()
    end,
  },

  -- codeium
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    init = function()
      require("codeium").setup({})
    end
  },

  {
    "erichlf/devcontainer-cli.nvim",
    branch = "main",
    dependencies = { 'akinsho/toggleterm.nvim' },
    keys = {
      {
        "<leader>Du",
        "<CMD>DevcontainerUp<CR>",
        desc = "Bring Up the DevContainer",
      },
      {
        "<leader>De",
        "<CMD>DevcontainerExec direction='horizontal'<CR>",
        desc = "Execute a command in the DevContainer",
      },
      {
        "<leader>Db",
        "<CMD>DevcontainerExec cmd='colcon build --symlink-install --merge-install' direction='horizontal'<CR>",
        desc = "ROS2 build in the DevContainer",
      },
      {
        "<leader>Dt",
        "<CMD>DevcontainerExec cmd='source install/setup.zsh && colcon test --merge-install' direction='horizontal'<CR>",
        desc = "ROS2 test in the DevContainer",
      },
      {
        "<leader>Dc",
        "<CMD>DevcontainerConnect<CR>",
        desc = "Connect to DevContainer",
      },
      {
        "<leader>DT",
        "<CMD>DevcontainerToggle<CR>",
        desc = "Toggle the current DevContainer Terminal"
      },
    },
    init = function()
      local opts = {
        interactive = false,
        dotfiles_repository = "https://github.com/erichlf/dotfiles.git",
        dotfiles_branch = "main",
        dotfiles_targetPath = "~/dotfiles",
        dotfiles_installCommand = "install.sh",
        nvim_binary = "lvim",
        shell = "zsh",
      }
      require("devcontainer-cli").setup(opts)
    end,
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
    init = function()
      require("gitlab").setup()
    end,
  },

  -- hardtimes aka hardmode
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {}
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

  -- hints
  {
    "tris203/precognition.nvim",
    opts = {},
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
    init = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
      }
    end
  },

  -- treesitter plugins
  {
    "nvim-treesitter/nvim-treesitter-context",
    init = function()
      require 'treesitter-context'.setup {
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 10, -- Maximum number of lines to show for a single context
        trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,     -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end
  },

  -- rainbow brackets
  { "mrjones2014/nvim-ts-rainbow", },
}
