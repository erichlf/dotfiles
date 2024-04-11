-- for conciseness
local mappings = lvim.builtin.which_key.mappings
local vmappings = lvim.builtin.which_key.vmappings

-- unmap things that I want to use
mappings["/"] = {} -- comment
mappings[";"] = {} -- Dashboard
mappings["b"]["b"] = {} -- previous buffer
mappings["c"] = {} -- close buffer 
mappings["h"] = {} -- no highlight
mappings["s"] = {} -- search
mappings["w"] = {} -- save
vmappings["/"] = {} -- comment 

-- set menu items
mappings["D"] = { name = "Devcontainer" }
mappings["f"] = { name = "Files" }
mappings["q"] = { name = "Quit" }
mappings["/"] = { name = "Search" }
mappings["w"] = { name = "Windows" }

mappings["+"] = { "<C-a>", "Increment Number" } -- increment
mappings["-"] = { "<C-x>", "Decrement Number" } -- decrement

------------------------ buffers operations --------------------------------------------
mappings["<Tab>"] = { "<CMD>edit #<CR>", "Previous Active Buffer" }
mappings["1"] = { "<CMD>BufferLineGoToBuffer 1<CR>", "Select Buffer 1" }
mappings["2"] = { "<CMD>BufferLineGoToBuffer 2<CR>", "Select Buffer 2" }
mappings["3"] = { "<CMD>BufferLineGoToBuffer 3<CR>", "Select Buffer 3" }
mappings["4"] = { "<CMD>BufferLineGoToBuffer 4<CR>", "Select Buffer 4" }
mappings["5"] = { "<CMD>BufferLineGoToBuffer 5<CR>", "Select Buffer 5" }
mappings["6"] = { "<CMD>BufferLineGoToBuffer 6<CR>", "Select Buffer 6" }
mappings["7"] = { "<CMD>BufferLineGoToBuffer 7<CR>", "Select Buffer 7" }
mappings["8"] = { "<CMD>BufferLineGoToBuffer 8<CR>", "Select Buffer 8" }
mappings["9"] = { "<CMD>BufferLineGoToBuffer 9<CR>", "Select Buffer 9" }

mappings["b/"] = { "<CMD>Telescope buffers previewer=false<CR>", "Find" }
mappings["bd"] = { "<CMD>BufferKill<CR>", "Close" }
mappings["bD"] = { "<CMD>BufferSortByDirectory<CR>", "Sort by Directory" }
mappings["bj"] = { "<CMD>BufferLinePick<CR>", "Jump" }
mappings["bl"] = { "<CMD>BufferLineSortByExtension<CR>", "Sort by Language" }
mappings["bL"] = { "<CMD>BufferLineCloseLeft<CR>", "Close All to Left" }
mappings["bn"] = { "<CMD>BufferLineCycleNext<CR>", "Next" }
mappings["bN"] = { "<CMD>tabnew<CR>", "New" }
mappings["bp"] = { "<CMD>BufferLineCyclePrev<CR>", "Previous" }
mappings["bR"] = { "<CMD>BufferLineCloseRight<CR>", "Close All to Right" }
mappings["bM"] = { "<CMD>BufferLineCloseOther<CR>", "Close All Other" }

-- command
-- here and keymaps cause otherwise it doesn't load immediately
mappings["<leader>"] = { "<cmd>FineCmdline<CR>", "Command" } 

-- comment lines 
mappings[";"] = { "<Plug>(comment_toggle_linewise_current)<CR>", "Toggle Comment" }
vmappings[";"] =  { "<Plug>(comment_toggle_linewise_visual)<CR>", "Toggle Comment" }

-- Dashboard
mappings["H"] = { "<CMD>Alpha<CR>", "Dashboard" }

-- Devcontainer
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs+1] = {
  "devcontainer exec --workspace-folder . zsh", 
  "<M-4>", 
  "Bring Up Terminal in Devcontainer", 
  "float", 
  nil 
}
-- mappings["De"] = {
--   "<CMD>103TermExec cmd='devcontainer exec --workspace . zsh' dir='.'<CR>",
--   "Bring Up Terminal in Devcontainer"
-- }
mappings["Dc"] = {
  "<CMD>104TermExec cmd='colcon build --symlink-install --merge-install'<CR>",
  "ROS2 Build"
}
mappings["Dt"] = {
  "<CMD>104TermExec cmd='source install/setup.zsh && colcon test --merge-install'<CR>",
  "ROS2 Test"
}

-- function launch()
--   return "<CMD>104TermExec cmd='source install/setup.zsh && ros2 launch " .. vim.fn.input("Package:", "", "") .. vim.fn.input("Launcher:", "", "") .. "'<CMD>"
-- end
-- mappings["Dl"] = { launch(), "ROS2 Launch" }

-- file  operations 
mappings["fr"] = { "<CMD>Telescope oldfiles<CR>", "Recent" }
mappings["fe"] = { "<CMD>NvimTreeToggle<CR>", "Toggle Explorer" }
mappings["fS"] = { "<CMD>wa<CR>", "Save All" }
mappings["fs"] = { "<CMD>w<CR>", "Save Current" }
mappings["fW"] = { "<CMD>noautocmd wa<CR>", "Save All (noautocmd)" }
mappings["fw"] = { "<CMD>noautocmd w<CR>", "Save Current (noautocmd)" }

-- git
mappings["gL"] = { "<CMD>LazyGit<CR>", "LazyGit" }

-- quiting 
mappings["qq"] = { "<CMD>qa<CR>", "Quit without Saving" }
mappings["qQ"] = { "<CMD>qa!<CR>", "Force Quit without Saving" }
mappings["qx"] = { "<CMD>x<CR>", "Quit and Save" }

-- search
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

-- window  operations 
mappings["wd"] = { "<CMD>close<CR>", "Close" }
mappings["wD"] = { "<CMD>other<CR>", "Close All Other" }
mappings["ws"] = { "<CMD>split<CR>", "Split Horizontal" }
mappings["wt"] = { "<CMD>tab split<CR>", "Send to Tab" }
mappings["wv"] = { "<CMD>vsplit<CR>", "Split Vertical" }
