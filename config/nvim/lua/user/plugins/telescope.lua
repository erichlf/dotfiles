return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.providers.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.smart_open_with_trouble,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- helper for keymaps
    local function map(l, r, desc)
      vim.keymap.set("n", l, r, { desc = desc })
    end

    -- set keymaps
    map("<leader>/c", "<cmd>Telescope grep_string<cr>", "Find string under cursor in cwd")
    map("<leader>/C", "<cmd>Telescope commands<CR>", "Commands")
    map("<leader>/f", "<cmd>Telescope find_files<CR>", "Find File")
    map("<leader>/h", "<cmd>Telescope help_tags<CR>", "Find Help")
    map("<leader>/H", "<cmd>Telescope highlights<CR>", "Find Highlight Groups")
    map("<leader>/k", "<cmd>Telescope keymaps<CR>", "Keymaps")
    map("<leader>/l", "<cmd>Telescope resume<CR>", "Resume last search")
    map("<leader>/M", "<cmd>Telescope man_pages<CR>", "Man Pages")
    map("<leader>/r", "<cmd>Telescope oldfiles<CR>", "Open Recent File")
    map("<leader>/R", "<cmd>Telescope registers<CR>", "Registers")
    map("<leader>/t", "<cmd>Telescope live_grep<CR>", "Text")
    map("<leader>/T", "<cmd>TodoTelescope<cr>", "Find todos")
  end,
}
