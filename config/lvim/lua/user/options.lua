vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- line numbering
opt.number = true
opt.relativenumber = true

-- tabs & indentation
opt.tabstop = 2       -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2    -- 2 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- lvim options
lvim.format_on_save.enabled = false
lvim.builtin.treesitter.highlight.enable = true

-- auto install treesitter parsers
lvim.builtin.treesitter.ensure_installed = { "cpp", "c", "lua", "python", "yaml" }

-- load telescope extensions
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  -- any other extensions loading
  pcall(telescope.load_extension, "media_files")
  pcall(telescope.load_extension, "noice")
  pcall(telescope.load_extension, "project")
end
lvim.builtin.telescope.defaults.layout_strategy = "horizontal"

-- buffer line options
lvim.builtin.bufferline.options.middle_mouse_command = "bdelete! %d"
lvim.builtin.bufferline.options.numbers = "ordinal"
lvim.builtin.bufferline.options.separator_style = "slant"

-- tell project where my projects start
lvim.builtin.project.patterns = { ".devcontainer", ".git", "!develop/.devcontainer" }

-- add devcontainer button to dashboard
table.insert(lvim.builtin.alpha.dashboard.section.buttons.entries,
  { "D", lvim.icons.misc.Package .. "  Bringup Devcontainer",
    "<CMD>lua require('devcontainer_cli.devcontainer_cli').up()<CR>" }
)

-- LSP
lvim.lsp.installer.setup.ensure_installed = {
  "clangd",
  "cmake",
  "docker_compose_language_service",
  "dockerls",
  "lemminx",
  "lua_ls",
  "pyright",
  "taplo",
  "yamlls",
}
require("lvim.lsp.null-ls.formatters").setup {
  { name = "black" },
  { name = "clang-format" },
  { name = "isort" },
  { name = "yamlfmt" },
}
require("lvim.lsp.null-ls.linters").setup {
  { name = "cmakelint" },
  { name = "cpplint" },
  { name = "cpptools" },
  { name = "flake8" },
  { name = "markdownlint" },
  { name = "pylint" },
  { name = "yamllint" },
}
