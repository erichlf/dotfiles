-- for conciseness
local mappings = lvim.builtin.which_key.mappings
local vmappings = lvim.builtin.which_key.vmappings

-- unmap things that I want to use
mappings["/"] = {}      -- comment
mappings[";"] = {}      -- Dashboard
mappings["b"]["b"] = {} -- previous buffer
mappings["b"]["D"] = {} -- BufferLineSortByDirectory
mappings["b"]["l"] = {} -- BufferLineCloseRight
mappings["b"]["L"] = {} -- sort by language
mappings["g"]["b"] = {} -- git new branch
mappings["g"]["l"] = {} -- git blame
mappings["g"]["L"] = {} -- git blame
mappings["bf"] = {}     -- buffer find
mappings["c"] = {}      -- close buffer
mappings["s"] = {}      -- search
mappings["w"] = {}      -- save
vmappings["/"] = {}     -- comment

-- set menu items
mappings["D"] = { name = "Devcontainer" }
mappings["f"] = { name = "Files" }
mappings["q"] = { name = "Quit" }
mappings["/"] = { name = "Search" }
mappings["w"] = { name = "Windows" }

mappings["+"] = { "<C-a>", "Increment Number" } -- increment
mappings["-"] = { "<C-x>", "Decrement Number" } -- decrement

-- buffers operations
mappings["<Tab>"] = { "<CMD>edit #<CR>", "Previous Active Buffer" }
mappings["0"] = { "<CMD>NvimTreeFocus<CR>", "Focus Explorer" }
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
mappings["bb"] = { "<cmd>Telescope oldfiles<CR>", "Open Recent File" }
mappings["bd"] = { "<CMD>BufferKill<CR>", "Close" }
mappings["bD"] = { "<CMD>BufferSortByDirectory<CR>", "Sort by Directory" }
mappings["bj"] = { "<CMD>BufferLinePick<CR>", "Jump" }
mappings["bl"] = { "<CMD>BufferLineSortByExtension<CR>", "Sort by Language" }
mappings["bL"] = { "<CMD>BufferLineCloseLeft<CR>", "Close All to Left" }
mappings["bM"] = { "<CMD>BufferLineCloseLeft<CR><CMD>BufferLineCloseRight<CR>", "Close All Other" }
mappings["bn"] = { "<CMD>BufferLineCycleNext<CR>", "Next" }
mappings["bN"] = { "<CMD>tabnew<CR>", "New" }
mappings["bp"] = { "<CMD>BufferLineCyclePrev<CR>", "Previous" }
mappings["bR"] = { "<CMD>BufferLineCloseRight<CR>", "Close All to Right" }

-- command
mappings["<leader>"] = { "<cmd>FineCmdline<CR>", "Command" }

-- comment lines
mappings[";"] = { "<Plug>(comment_toggle_linewise_current)<CR>", "Toggle Comment" }
vmappings[";"] = { "<Plug>(comment_toggle_linewise_visual)<CR>", "Toggle Comment" }

-- Dashboard
mappings["H"] = { "<CMD>Alpha<CR>", "Dashboard" }

-- file operations
mappings["fr"] = { "<CMD>Telescope oldfiles<CR>", "Recent" }
mappings["fe"] = { "<CMD>NvimTreeToggle<CR>", "Toggle Explorer" }
mappings["fS"] = { "<CMD>wa<CR>", "Save All" }
mappings["fs"] = { "<CMD>w<CR>", "Save Current" }
mappings["fW"] = { "<CMD>noautocmd wa<CR>", "Save All (noautocmd)" }
mappings["fw"] = { "<CMD>noautocmd w<CR>", "Save Current (noautocmd)" }

-- git
mappings["gl"] = { "<CMD>LazyGit<CR>", "LazyGit (float)" }
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
