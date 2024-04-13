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
nmap("<C-h>", "<C-W><Left>")
nmap("<C-j>", "<C-W><Down>")
nmap("<C-k>", "<C-W><Up>")
nmap("<C-l>", "<C-W><Right>")

-- command
-- nmap(":", "<cmd>FineCmdline<CR>", {noremap = true})
nmap("<leader><leader>", "<cmd>FineCmdline<CR>", {desc = "Command", noremap = true})

-- comments
nmap(";;", "<Plug>(comment_toggle_linewise)<CR>")
vmap(";", "<Plug>(comment_toggle_linewise_visual)<CR>")
