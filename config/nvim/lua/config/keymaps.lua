-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- custom keymaps
-- for conciseness
local keymap = vim.keymap
local wk = require("which-key")

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

local function unmap(mode, l)
  keymap.del(mode, l)
end

local function nunmap(l)
  unmap("n", l)
end

local function vunmap(l)
  unmap("v", l)
end

local function wunmap(l)
  nunmap("<leader>" .. l)
end

local function wgroup(groups)
  for key, value in pairs(groups) do
    wk.add({ "<leader>" .. key, group = value })
  end
end

local function wmap(mode, mappings)
  for key, value in pairs(mappings) do
    local mapping = "<leader>" .. key
    local command = value[1]
    local description = value[2]

    wk.add({ mapping, command, desc = description, mode = mode })
  end
end

local function wnmap(mappings)
  wmap("n", mappings)
end

local function wvmap(mappings)
  wmap("v", mappings)
end

-- custom which-key mappings
local groups = {}
local mappings = {}
local vmappings = {}

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

nmap("<M-3>", "<leader>Tf")
nmap("<M-2>", "<leader>Th")
nmap("<M-1>", "<leader>Tv")

-- which-key setup
-- unmap things that I want to use
wunmap("`")
wunmap("fb")
wunmap("fc")
wunmap("fe")
wunmap("fE")
wunmap("ft")
wunmap("fT")
wunmap("gg")
wunmap("gG")
wunmap("bo")
wunmap("bl")
wunmap("br")

-- set menu items
groups["D"] = "+devcontainer"
groups["f"] = "+files"
groups["/"] = "+search"
groups["t"] = "+terminal"

wgroup(groups)

mappings["+"] = { "<C-a>", "Increment Number" } -- increment
mappings["-"] = { "<C-x>", "Decrement Number" } -- decrement
mappings["h"] = { "<CMD>nohlsearch<CR>", "No Highlight" }

-- buffers operations
mappings["<Tab>"] = { "<CMD>edit #<CR>", "Previous Active Buffer" }
mappings["0"] = {
  function()
    require("neo-tree.command").execute({ toggle = false, dir = vim.uv.cwd() })
  end,
  "Focus Explorer",
}
mappings["1"] = { "<CMD>BufferLineGoToBuffer 1<CR>", "Select Buffer 1" }
mappings["2"] = { "<CMD>BufferLineGoToBuffer 2<CR>", "Select Buffer 2" }
mappings["3"] = { "<CMD>BufferLineGoToBuffer 3<CR>", "Select Buffer 3" }
mappings["4"] = { "<CMD>BufferLineGoToBuffer 4<CR>", "Select Buffer 4" }
mappings["5"] = { "<CMD>BufferLineGoToBuffer 5<CR>", "Select Buffer 5" }
mappings["6"] = { "<CMD>BufferLineGoToBuffer 6<CR>", "Select Buffer 6" }
mappings["7"] = { "<CMD>BufferLineGoToBuffer 7<CR>", "Select Buffer 7" }
mappings["8"] = { "<CMD>BufferLineGoToBuffer 8<CR>", "Select Buffer 8" }
mappings["9"] = { "<CMD>BufferLineGoToBuffer 9<CR>", "Select Buffer 9" }

mappings["b/"] = { "<CMD>Telescope buffers previewer=true<CR>", "Find" }
mappings["b]"] = { "<CMD>BufferLineCycleNext<CR>", "Next" }
mappings["b["] = { "<CMD>BufferLineCyclePrev<CR>", "Previous" }
mappings["bb"] = { "<CMD>Telescope oldfiles<CR>", "Open Recent File" }
mappings["bD"] = { "<CMD>BufferSortByDirectory<CR>", "Sort by Directory" }
mappings["bj"] = { "<CMD>BufferLinePick<CR>", "Jump" }
mappings["bl"] = { "<CMD>BufferLineSortByExtension<CR>", "Sort by Language" }
mappings["bL"] = { "<CMD>BufferLineCloseLeft<CR>", "Close All to Left" }
mappings["bN"] = { "<CMD>tabnew<CR>", "New" }
mappings["bO"] = { "<CMD>BufferLineCloseLeft<CR><CMD>BufferLineCloseRight<CR>", "Close All Other" }
mappings["bR"] = { "<CMD>BufferLineCloseRight<CR>", "Close All to Right" }

-- command
mappings["<leader>"] = { "<cmd>FineCmdline<CR>", "Command" }

-- comment lines
mappings[";"] = { "<Plug>(comment_toggle_linewise_current)<CR>", "Toggle Comment" }
vmappings[";"] = { "<Plug>(comment_toggle_linewise_visual)<CR>", "Toggle Comment" }

-- Dashboard
mappings["H"] = { "<CMD>Alpha<CR>", "Dashboard" }

-- Devcontainer
mappings["Du"] = { "<CMD>DevcontainerUp<CR>", "Bring Up the DevContainer" }
mappings["Dd"] = { "<CMD>DevcontainerDown<CR>", "Kill the Current DevContainer" }
mappings["De"] = {
  "<CMD>DevcontainerExec direction='horizontal'<CR>",
  "Execute a command in the DevContainer",
}
mappings["Db"] = {
  "<CMD>DevcontainerExec cmd='colcon build --symlink-install --merge-install' direction='horizontal'<CR>",
  "ROS2 build in the DevContainer",
}
mappings["Dt"] = {
  "<CMD>DevcontainerExec cmd='source install/setup.zsh && colcon test --merge-install' direction='horizontal'<CR>",
  "ROS2 test in the DevContainer",
}
mappings["Dc"] = { "<CMD>DevcontainerConnect<CR>", "Connect to DevContainer" }
mappings["DT"] = { "<CMD>DevcontainerToggle<CR>", "Toggle the current DevContainer Terminal" }

-- file operations
mappings["fr"] = { "<CMD>Telescope oldfiles<CR>", "Recent" }
mappings["fe"] = { "<CMD>NvimTreeToggle<CR>", "Toggle Explorer" }
mappings["fS"] = { "<CMD>wa<CR>", "Save All" }
mappings["fs"] = { "<CMD>w<CR>", "Save Current" }
mappings["fW"] = { "<CMD>noautocmd wa<CR>", "Save All (noautocmd)" }
mappings["fw"] = { "<CMD>noautocmd w<CR>", "Save Current (noautocmd)" }
mappings["fo"] = { "<CMD>Oil --float .<CR>", "Open Oil in Current Path" }

-- git
mappings["gl"] = { "<CMD>LazyGitCurrentFile<CR>", "LazyGit (float)" }
mappings["gb"] = { "<CMD>Gitsigns toggle_current_line_blame<CR>", "Blame" }

-- gitlab
mappings["gL"] = { name = "GitLab" }
mappings["gLb"] = { "<CMD>lua require('gitlab').choose_merge_request()<CR>", "Choose Merge Request" }
mappings["gLr"] = { "<CMD>lua require('gitlab').review()<CR>", "Review" }
mappings["gLs"] = { "<CMD>lua require('gitlab').summary()<CR>", "Summary" }
mappings["gLA"] = { "<CMD>lua require('gitlab').approve()<CR>", "Approve" }
mappings["gLR"] = { "<CMD>lua require('gitlab').revoke()<CR>", "Revoke" }
mappings["gLc"] = { "<CMD>lua require('gitlab').create_comment()<CR>", "Comment" }
mappings["gLc"] = { "<CMD>lua require('gitlab').create_multiline_comment()<CR>", "Multiline Comment" }
mappings["gLC"] = { "<CMD>lua require('gitlab').create_comment_suggestion()<CR>", "Suggestion" }
mappings["gLO"] = { "<CMD>lua require('gitlab').create_mr()<CR>", "Create Merge Request" }
mappings["gLm"] = { "<CMD>lua require('gitlab').move_to_discussion_tree_from_diagnostic()<CR>", "Discussion Tree" }
mappings["gLn"] = { "<CMD>lua require('gitlab').create_note()<CR>", "Note" }
mappings["gLd"] = { "<CMD>lua require('gitlab').toggle_discussions()<CR>", "Toggle Discussion" }
mappings["gLa"] = { name = "Assignee" }
mappings["gLaa"] = { "<CMD>lua require('gitlab').add_assignee()<CR>", "Add Assignee" }
mappings["gLad"] = { "<CMD>lua require('gitlab').delete_assignee()<CR>", "Remove Assignee" }
mappings["gLla"] = { "<CMD>lua require('gitlab').add_label()<CR>", "Add Label" }
mappings["gLld"] = { "<CMD>lua require('gitlab').delete_label()<CR>", "Remove Label" }
mappings["gLr"] = { name = "Reviewer" }
mappings["gLra"] = { "<CMD>lua require('gitlab').add_reviewer()<CR>", "Add Reviewer" }
mappings["gLrd"] = { "<CMD>lua require('gitlab').delete_reviewer()<CR>", "Remove Reviewer" }
mappings["gLp"] = { "<CMD>lua require('gitlab').pipeline()<CR>", "Pipeline" }
mappings["gLo"] = { "<CMD>lua require('gitlab').open_in_browser()<CR>", "Open in Browser" }
mappings["gLM"] = { "<CMD>lua require('gitlab').merge()<CR>", "Merge" }
mappings["gLu"] = { "<CMD>lua require('gitlab').copy_mr_url()<CR>", "Copy URL" }
mappings["gLP"] = { "<CMD>lua require('gitlab').publish_all_drafts()<CR>", "Publish Draft" }

-- quiting
mappings["qq"] = { "<CMD>qa<CR>", "Quit without Saving" }
mappings["qQ"] = { "<CMD>qa!<CR>", "Force Quit without Saving" }
mappings["qx"] = { "<CMD>x<CR>", "Quit and Save" }

-- search
mappings["/b"] = { "<CMD>Telescope buffers previewer=true<CR>", "Find Buffer" }
mappings["/c"] = { "<cmd>Telescope colorscheme<CR>", "Colorscheme" }
mappings["/f"] = { "<cmd>Telescope find_files<CR>", "Find File" }
mappings["/h"] = { "<cmd>Telescope help_tags<CR>", "Find Help" }
mappings["/H"] = { "<cmd>Telescope highlights<CR>", "Find highlight groups" }
mappings["/M"] = { "<cmd>Telescope man_pages<CR>", "Man Pages" }
mappings["/r"] = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" }
mappings["/R"] = { "<cmd>Telescope registers<CR>", "Registers" }
mappings["/t"] = { "<cmd>Telescope live_grep<CR>", "Text" }
mappings["/k"] = { "<cmd>Telescope keymaps<CR>", "Keymaps" }
mappings["/C"] = { "<cmd>Telescope commands<CR>", "Commands" }
mappings["/l"] = { "<cmd>Telescope resume<CR>", "Resume last search" }

-- window operations
mappings["wd"] = { "<CMD>close<CR>", "Close" }
mappings["wD"] = { "<CMD>other<CR>", "Close All Other" }
mappings["ws"] = { "<CMD>split<CR>", "Split Horizontal" }
mappings["wt"] = { "<CMD>tab split<CR>", "Send to Tab" }
mappings["wv"] = { "<CMD>vsplit<CR>", "Split Vertical" }

wnmap(mappings)
wvmap(vmappings)
