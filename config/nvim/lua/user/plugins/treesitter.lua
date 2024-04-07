return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup(
      { -- enable syntax highlighting
        -- A list of parser names, or "all"
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "comment",
          "cpp",
          "csv",
          "diff",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "json", -- for devcontainers
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "ssh_config",
          "svelte",
          "tmux",
          "toml",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
        -- List of parsers to ignore installing (for "all")
        ignore_install = {},

        -- A directory to install the parsers into.
        -- By default parsers are installed to either the package dir, or the "site" dir.
        -- If a custom path is used (not nil) it must be added to the runtimepath.
        parser_install_dir = nil,

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        matchup = {
          enable = false, -- mandatory, false will disable the whole extension
          -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
        },
        highlight = { enable = true, },
        -- enable indentation
        indent = { enable = true, disable = { "yaml", "python" } },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = { enable = true, },
        -- ensure these language parsers are installed
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        rainbow = {
          enable = false,
          extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
          max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
      }
    )
  end,
}
