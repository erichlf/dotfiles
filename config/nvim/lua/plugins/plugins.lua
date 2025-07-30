return {
  -- auto complete tags
  {
    "windwp/nvim-ts-autotag",
    init = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "erichlf/devcontainer-cli.nvim",
    -- dir = "/home/elfoster/workspace/devcontainer-cli.nvim/",
    branch = "main",
    dependencies = { "akinsho/toggleterm.nvim" },
    init = function()
      local opts = {
        interactive = false,
        dotfiles_repository = "https://github.com/erichlf/dotfiles.git",
        dotfiles_branch = "main",
        dotfiles_targetPath = "~/dotfiles",
        dotfiles_installCommand = "install.sh",
        nvim_binary = "/home/linuxbrew/.linuxbrew/bin/nvim",
        shell = "zsh",
      }
      require("devcontainer-cli").setup(opts)
    end,
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

  -- hardtimes aka hardmode
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      disable_mouse = false,
    },
  },

  -- images
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  -- interface
  { "stevearc/dressing.nvim" },

  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "clang-format@14.0.0",
        "clangd",
        "cmakelang",
        "codespell",
        "debugpy",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "hadolint",
        "isort",
        "jupytext",
        "luacheck",
        "luaformatter",
        "lua-language-server",
        "markdown-oxide",
        "markdown-toc",
        "markdownlint",
        "markdownlint-cli2",
        "marksman",
        "misspell",
        "neocmakelsp",
        "pyright",
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "taplo",
        "yamlfmt",
        "yamllint",
        "yaml-language-server",
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      group_empty_dirs = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },
    },
  },

  -- hints
  {
    "tris203/precognition.nvim",
    opts = {},
  },

  -- python
  {
    "nvim-neotest/neotest",
    dependencies = "nvim-neotest/nvim-nio",
  },
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
    "alexghergh/nvim-tmux-navigation",
    init = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true, -- defaults to false
      })
    end,
  },

  -- treesitter plugins
  {
    "nvim-treesitter/nvim-treesitter-context",
    init = function()
      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 10, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "cpp",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "vim",
        "xml",
        "yaml",
      })

      return opts
    end,
  },

  -- trim trailing whitespace
  {
    "cappyzawa/trim.nvim",
    opts = {
      trim_last_line = false,
      trim_first_line = false,
    },
  },

  -- rainbow brackets
  { "mrjones2014/nvim-ts-rainbow" },
}
