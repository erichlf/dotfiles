-- vim options
vim.wo.relativenumber = true -- turn on relative line numbers
vim.opt.shiftwidth = 2  -- the number of spaces used for each indentation
vim.opt.tabstop = 2  -- insert 2 spaces for a tab

-- lvim options
lvim.format_on_save = true
-- vim.diagnostic.config({virtual_text = true})

lvim.builtin.treesitter.highlight.enable = true

-- auto install treesitter parsers
lvim.builtin.treesitter.ensure_installed = { "cpp", "c", "lua", "python" }

-- lvim.transparent_window = true

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  -- any other extensions loading
  pcall(telescope.load_extension, "project")
end

lvim.builtin.bufferline.options.middle_mouse_command = "bdelete! %d"
lLim.builtin.bufferline.options.numbers = "ordinal"
lvim.builtin.bufferline.options.separator_style = "slant" 
