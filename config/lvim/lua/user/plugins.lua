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

  -- devctontainer management
  {
    "arnaupv/nvim-devcontainer-cli",
    branch = "main",
    opts = {
      -- By default, if no extra config is added, following nvim_dotfiles are
      -- installed: "https://github.com/LazyVim/starter"
      -- This is an example for configuring other nvim_dotfiles inside the docker container
      system_environment_repo = "\\-b devcontainer https://github.com/erichlf/dotfiles.git",
      system_environment_directory = "dotfiles",
      system_environment_install_command = "./install.sh",
      nvim_dotfiles_repo = "",
      nvim_dotfiles_branch = "",
      nvim_dotfiles_directory = "",
      nvim_dotfiles_install_command = "",
      -- In case you want to change the way the devenvironment is setup, you can also provide your own setup
      -- setup_environment_repo = "https://github.com/arnaupv/setup-environment",
      -- setup_environment_install_command = "./install.sh -p 'nvim stow zsh'",
    },
    keys = {
      -- stylua: ignore
      {
        "<leader>Du",
        "<CMD>DevcontainerUp<CR>",
        desc = "Bring Up the DevContainer",
      },
      {
        "<leader>Dc",
        "<CMD>DevcontainerConnect<CR>",
        desc = "Connect to DevContainer",
      },
      }
  },

  -- fine command
  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
      {'MunifTanjim/nui.nvim'}
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
      { "<leader>gL", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit" },
    },
  },

  -- python
  {"stevearc/dressing.nvim"},
  {"nvim-neotest/neotest"},
  {"nvim-neotest/neotest-python"},
  {"mfussenegger/nvim-dap-python"},
  {"ChristianChiarulli/swenv.nvim"},

  -- project tracking
  { 
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
  },
  
  -- tmux
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
      { "<M-Left>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<M-Down>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<M-Up>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<M-Right>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<M-Tab>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- rainbow brackets
  { "mrjones2014/nvim-ts-rainbow", },
}
