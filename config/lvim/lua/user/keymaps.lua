-- for conciseness
local keymap = vim.keymap
local mappings = lvim.builtin.which_key.mappings
local vmappings = lvim.builtin.which_key.vmappings

-- helper for keymaps
local function map(mode, l, r, opts)
  keymap.set(mode, l, r, opts)
end

local function nmap(l, r, opts)
  map("n", l, r, opts)
end

local function vmap(l, r, opts)
  map("v", l, r, opts)
end

-- navigation between window panes
nmap("<C-h>", "<CMD>NvimTmuxNavigateLeft<CR>")
nmap("<C-j>", "<CMD>NvimTmuxNavigateDown<CR>")
nmap("<C-k>", "<CMD>NvimTmuxNavigateUp<CR>")
nmap("<C-l>", "<CMD>NvimTmuxNavigateRight<CR>")
nmap("<C-Tab>", "<CMD>NvimTmuxNavigateLastActive<CR>")
nmap("<C-Space>", "<CMD>NvimTmuxNavigateNext<CR>")

nmap("<M-Right>", "<CMD>BufferLineCycleNext<CR>")
nmap("<M-Left>", "<CMD>BufferLineCyclePrev<CR>")

-- comments
nmap(";;", "<Plug>(comment_toggle_linewise)<CR>")
vmap(";", "<Plug>(comment_toggle_linewise_visual)<CR>")
