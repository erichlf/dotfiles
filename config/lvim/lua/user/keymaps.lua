-- for conciseness
local keymap = vim.keymap

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

-- comments
nmap(";;", "gcc", { remap = true })
nmap(";A", "gcA", { remap = true })
nmap(";p", "gcap", { remap = true })
nmap(";o", "gco", { remap = true })
nmap(";O", "gcO", { remap = true })
vmap(";", "gc", { remap = true })

-- navigation
nmap("H", "Hzz")
nmap("L", "Lzz")

-- navigation between window panes
nmap("<C-h>", "<CMD>NvimTmuxNavigateLeft<CR>")
nmap("<C-j>", "<CMD>NvimTmuxNavigateDown<CR>")
nmap("<C-k>", "<CMD>NvimTmuxNavigateUp<CR>")
nmap("<C-l>", "<CMD>NvimTmuxNavigateRight<CR>")
nmap("<C-Tab>", "<CMD>NvimTmuxNavigateLastActive<CR>")
nmap("<C-Space>", "<CMD>NvimTmuxNavigateNext<CR>")

-- navigation between buffers
nmap("<M-Right>", "<CMD>BufferLineCycleNext<CR>")
nmap("<M-Left>", "<CMD>BufferLineCyclePrev<CR>")

lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = {
  "devcontainer exec --workspace-folder . zsh",
  "<M-4>",
  "Bring Up Terminal in Devcontainer",
  "float",
  nil
}

