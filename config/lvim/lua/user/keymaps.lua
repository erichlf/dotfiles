vim.g.mapleader = " "

-- for conciseness
local keymap = vim.keymap

-- navigation between window panes
keymap.set("n", "<A-Left>", "<C-W><Left>")
keymap.set("n","<A-Right>", "<C-W><Right>")
keymap.set("n","<A-Up>", "<C-W><Up>")
keymap.set("n","<A-Down>", "<C-W><Down>")

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment Number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement Number" }) -- decrement

-- dashboard/home screen
keymap.set("n", "<leader>H", "<cmd>Alpha<CR>", { desc = "Dashboard" })

-- comment lines
keymap.set(
  "n", 
  "<leader>;", 
  "<Plug>(comment_toggle_linewise_current)<CR>", 
  { desc = "Comment toggle current line" }
)
keymap.set("n", ";;", "<Plug>(comment_toggle_linewise)<CR>")
keymap.set("n", ";", "<Plug>(comment_toggle_linewise_visual)<CR>")
keymap.set(
   "v", 
   "<leader>;", 
   "<Plug>(comment_toggle_linewise_visual)<CR>", 
   { desc = "Comment Toggle Linewise (visual)" }
)

-- file operations
keymap.set("n", "<leader>f/",
  function()
    require("lvim.core.telescope.custom-finders").find_project_files {
      previewer = true,
      layout_strategy = "horizontal",
    }
  end,
  { desc = "Find"}
)
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent"})
keymap.set("n", "<leader>fS", "<cmd>wa<CR>", { desc = "Save All"})
keymap.set("n", "<leader>fs", "<cmd>w<CR>", { desc = "Save Current"})
keymap.set("n", "<leader>fW", "<cmd>noautocmd wa<CR>", { desc = "Save All (noautocmd)"})
keymap.set("n", "<leader>fw", "<cmd>noautocmd w<CR>", { desc = "Save Current (noautocmd)"})
keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Explorer"})

-- quiting
keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit without Saving" })
keymap.set("n", "<leader>qQ", "<cmd>qa!<CR>", { desc = "Force Quit without Saving" })
keymap.set("n", "<leader>qX", "<cmd>x<CR>", { desc = "Quit and Save" })

-- search
keymap.set("n", "<leader>/c", "<cmd>Telescope colorscheme<CR>", { desc = "Colorscheme" })
keymap.set("n", "<leader>/f", "<cmd>Telescope find_files<CR>", { desc = "Find File" })
keymap.set("n", "<leader>/h", "<cmd>Telescope help_tags<CR>", { desc = "Find Help" })
keymap.set("n", "<leader>/H", "<cmd>Telescope highlights<CR>", { desc = "Find highlight groups" })
keymap.set("n", "<leader>/M", "<cmd>Telescope man_pages<CR>", { desc = "Man Pages" })
keymap.set("n", "<leader>/r", "<cmd>Telescope oldfiles<CR>", { desc = "Open Recent File" })
keymap.set("n", "<leader>/R", "<cmd>Telescope registers<CR>", { desc = "Registers" })
keymap.set("n", "<leader>/t", "<cmd>Telescope live_grep<CR>", { desc = "Text" })
keymap.set("n", "<leader>/k", "<cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
keymap.set("n", "<leader>/C", "<cmd>Telescope commands<CR>", { desc = "Commands" })
keymap.set("n", "<leader>/l", "<cmd>Telescope resume<CR>", { desc = "Resume last search" })
keymap.set(
  "n",
  "<leader>sp",
  "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<CR>",
  { desc = "Colorscheme with Preview" }
)

-- buffer operations
keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous" })
keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Previous" })
keymap.set("n", "<leader>bd", "<cmd>BufferKill<CR>", { desc = "Close" })
keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Select Buffer 1" })
keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Select Buffer 2" })
keymap.set("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Select Buffer 3" })
keymap.set("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Select Buffer 4" })
keymap.set("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Select Buffer 5" })
keymap.set("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", { desc = "Select Buffer 6" })
keymap.set("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", { desc = "Select Buffer 7" })
keymap.set("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", { desc = "Select Buffer 8" })
keymap.set("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", { desc = "Select Buffer 9" })

-- window operations
keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split Vertical" })
keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split Horizontal" })
keymap.set("n", "<leader>wt", "<cmd>tab split<CR>", { desc = "Send to Tab" })
keymap.set("n", "<leader>wd", "<cmd>close<CR>", { desc = "Close"})
keymap.set("n", "<leader>wD", "<cmd>other<CR>", { desc = "Close All Other"})

-- tab operations
keymap.set("n", "<leader><Tab>", "<cmd>edit #<CR>", { desc = "Previous Active Buffer" })

-- devcontainer
-- These are defined in the plugin
-- keymap.set("<leader>du", ":DevcontainerUp<cr>", { desc = "Bring Up Devcontainer" })
-- keymap.set("<leader>dc", ":DevcontainerConnect<cr>", { desc = "Connect to DevContainer" })
