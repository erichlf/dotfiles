return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")
    local icons = require("user.core.icons")

    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      -- view = {
      --   width = 35,
      --   relativenumber = true,
      -- },
      -- auto_reload_on_write = false,
      -- disable_netrw = false,
      -- hijack_cursor = false,
      -- hijack_netrw = true,
      -- hijack_unnamed_buffer_when_opening = false,
      -- sort_by = "name",
      -- root_dirs = {},
      -- prefer_startup_root = false,
      -- sync_root_with_cwd = true,
      -- reload_on_bufenter = false,
      -- respect_buf_cwd = false,
      -- on_attach = "default",
      -- select_prompts = false,
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "none",
        root_folder_label = ":t",
        indent_width = 2,
        indent_markers = {
          enable = false,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          },
        },
        icons = {
          git_placement = "before",
          padding = " ",
          symlink_arrow = " ➛ ",
          glyphs = {
            default = icons.ui.Text,
            symlink = icons.ui.FileSymlink,
            bookmark = icons.ui.BookMark,
            folder = {
              arrow_closed = icons.ui.TriangleShortArrowRight,
              arrow_open = icons.ui.TriangleShortArrowDown,
              default = icons.ui.Folder,
              open = icons.ui.FolderOpen,
              empty = icons.ui.EmptyFolder,
              empty_open = icons.ui.EmptyFolderOpen,
              symlink = icons.ui.FolderSymlink,
              symlink_open = icons.ui.FolderOpen,
            },
            git = {
              unstaged = icons.git.FileUnstaged,
              staged = icons.git.FileStaged,
              unmerged = icons.git.FileUnmerged,
              renamed = icons.git.FileRenamed,
              untracked = icons.git.FileUntracked,
              deleted = icons.git.FileDeleted,
              ignored = icons.git.FileIgnored,
            },
          },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
      },
      -- hijack_directories = {
      --   enable = false,
      --   auto_open = true,
      -- },
      -- update_focused_file = {
      --   enable = true,
      --   debounce_delay = 15,
      --   update_root = true,
      --   ignore_list = {},
      -- },
      -- filters = {
      --   dotfiles = false,
      --   git_clean = false,
      --   no_buffer = false,
      --   custom = { "node_modules", "\\.cache" },
      --   exclude = {},
      -- },
      -- filesystem_watchers = {
      --   enable = true,
      --   debounce_delay = 50,
      --   ignore_dirs = {},
      -- },
      -- git = {
      --   enable = true,
      --   ignore = false,
      --   show_on_dirs = true,
      --   show_on_open_dirs = true,
      --   timeout = 200,
      -- },
      -- -- disable window_picker for
      -- -- explorer to work well with
      -- -- window splits
      -- actions = {
      --   use_system_clipboard = true,
      --   change_dir = {
      --     enable = true,
      --     global = false,
      --     restrict_above_cwd = false,
      --   },
      --   expand_all = {
      --     max_folder_discovery = 300,
      --     exclude = {},
      --   },
      --   file_popup = {
      --     open_win_config = {
      --       col = 1,
      --       row = 1,
      --       relative = "cursor",
      --       border = "shadow",
      --       style = "minimal",
      --     },
      --   },
      --   open_file = {
      --     quit_on_open = false,
      --     resize_window = false,
      --     window_picker = {
      --       enable = true,
      --       picker = "default",
      --       chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
      --       exclude = {
      --         filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
      --         buftype = { "nofile", "terminal", "help" },
      --       },
      --     },
      --   },
      --   remove_file = {
      --     close_window = true,
      --   },

      --   open_file = {
      --     window_picker = {
      --       enable = false,
      --     },
      --   },
      -- },
      -- filters = {
      -- },
      -- git = {
      --   ignore = false,
      -- },
    }
    )

    -- set keymaps
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Explorer" }) -- toggle file explorer
  end
}
