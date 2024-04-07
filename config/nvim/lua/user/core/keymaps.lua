vim.g.mapleader = " "

-- plugin specific keymappings are defined in the plugins directory

-- for conciseness
local keymap = vim.keymap
-- helper for keymaps
local function map(mode, l, r, desc)
  keymap.set(mode, l, r, { desc = desc })
end

-- navigation between window panes
keymap.set("n", "<A-Left>", "<C-W><Left>")
keymap.set("n","<A-Right>", "<C-W><Right>")
keymap.set("n","<A-Up>", "<C-W><Up>")
keymap.set("n","<A-Down>", "<C-W><Down>")

map("n", "<leader>+", "<C-a>", "Increment Number") -- increment
map("n", "<leader>-", "<C-x>", "Decrement Number") -- decrement

------------------------ buffer line --------------------------------------------
-- TODO: Get these to work in the bufferline plugins file
map("n", "<leader><Tab>", "<CMD>edit #<CR>", "Previous Active Buffer")
map("n", "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>", "Select Buffer 1")
map("n", "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>", "Select Buffer 2")
map("n", "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>", "Select Buffer 3")
map("n", "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>", "Select Buffer 4")
map("n", "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>", "Select Buffer 5")
map("n", "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>", "Select Buffer 6")
map("n", "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>", "Select Buffer 7")
map("n", "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>", "Select Buffer 8")
map("n", "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>", "Select Buffer 9")

map("n", "<leader>b/", "<CMD>Telescope buffers previewer=false<CR>", "Find")
map("n", "<leader>bd", "<CMD>BufferKill<CR>", "Close")
map("n", "<leader>bD", "<CMD>BufferSortByDirectory<CR>", "Sort by Directory")
map("n", "<leader>bj", "<CMD>BufferLinePick<CR>", "Jump")
map("n", "<leader>bl", "<CMD>BufferLineSortByExtension<CR>", "Sort by Language")
map("n", "<leader>bL", "<CMD>BufferLineCloseLeft<CR>", "Close All to Left")
map("n", "<leader>bn", "<CMD>BufferLineCycleNext<CR>", "Next")
map("n", "<leader>bp", "<CMD>BufferLineCyclePrev<CR>", "Previous")
map("n", "<leader>bR", "<CMD>BufferLineCloseRight<CR>", "Close All to Right")
map("n", "<leader>bM", "<CMD>BufferLineCloseOther<CR>", "Close All Other")

------------------------ comment lines -------------------------------------------
map(
  "n", 
  "<leader>;", 
  "<Plug>(comment_toggle_linewise_current)<CR>", 
  "Comment toggle current line"
)
keymap.set("n", ";;", "<Plug>(comment_toggle_linewise)<CR>")
keymap.set("n", ";", "<Plug>(comment_toggle_linewise_visual)<CR>")
map(
   "v", 
   "<leader>;", 
   "<Plug>(comment_toggle_linewise_visual)<CR>", 
   "Comment Toggle Linewise (visual)"
)

----------------------------- file  operations -------------------------------------------- 
map("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>", "Recent")
map("n", "<leader>fe", "<CMD>NvimTreeToggle<CR>", "Toggle Explorer")
map("n", "<leader>fS", "<CMD>wa<CR>", "Save All")
map("n", "<leader>fs", "<CMD>w<CR>", "Save Current")
map("n", "<leader>fW", "<CMD>noautocmd wa<CR>", "Save All (noautocmd)")
map("n", "<leader>fw", "<CMD>noautocmd w<CR>", "Save Current (noautocmd)")

----------------------------- quiting -------------------------------------------- 
map("n", "<leader>qq", "<CMD>qa<CR>", "Quit without Saving")
map("n", "<leader>qQ", "<CMD>qa!<CR>", "Force Quit without Saving")
map("n", "<leader>qx", "<CMD>x<CR>", "Quit and Save")

----------------------------- window  operations -------------------------------------------- 
map("n", "<leader>wd", "<CMD>close<CR>", "Close")
map("n", "<leader>wD", "<CMD>other<CR>", "Close All Other")
map("n", "<leader>ws", "<CMD>split<CR>", "Split Horizontal")
map("n", "<leader>wt", "<CMD>tab split<CR>", "Send to Tab")
map("n", "<leader>wv", "<CMD>vsplit<CR>", "Split Vertical")
