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
    "erichlf/nvim-devcontainer-cli",
    branch = "root-from-devcontainer-dir",
    opts = {
      setup_environment_repo = "\"https://github.com/erichlf/dotfiles.git -b devcontainer \"",
      setup_environment_directory = "dotfiles",
      setup_environment_install_command = "./install.sh",
      nvim_dotfiles_repo = "",
      nvim_dotfiles_branch = "",
      nvim_dotfiles_directory = "",
      nvim_dotfiles_install_command = "",
    },
    keys = {
      -- stylua: ignore
      {
        "<leader>Du",
        "<CMD>DevcontainerUp<CR>",
        desc = "Bring Up the DevContainer",
      },
      -- {
      --   "<leader>Dc",
      --   "<CMD>DevcontainerConnect<CR>",
      --   desc = "Connect to DevContainer",
      -- },
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
      { "<leader>gL", "<CMD>LazyGitCurrentFile<CR>", desc = "LazyGit" },
    },
  },

  -- images
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  -- interface
  {"stevearc/dressing.nvim"},


  -- python
  {"nvim-neotest/neotest"},
  {"nvim-neotest/neotest-python"},
  {"mfussenegger/nvim-dap-python"},
  {"ChristianChiarulli/swenv.nvim"},

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
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<CMD><C-U>TmuxNavigateLeft<CR>" },
      { "<C-j>", "<CMD><C-U>TmuxNavigateDown<CR>" },
      { "<C-k>", "<CMD><C-U>TmuxNavigateUp<CR>" },
      { "<C-l>", "<CMD><C-U>TmuxNavigateRight<CR>" },
      { "<C-Tab>", "<CMD><C-U>TmuxNavigatePrevious<CR>" },
    },
  },

  -- rainbow brackets
  { "mrjones2014/nvim-ts-rainbow", },
}
