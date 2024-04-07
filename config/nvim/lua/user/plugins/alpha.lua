return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local button = dashboard.button

    -- TODO: figure out how to make the follow the theme as it does in lunarvim 
    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- for conciseness 
    local icons = require("user.core.icons")

    -- Set menu
    dashboard.section.buttons.val = {
      button(
        "n", 
        icons.ui.NewFile .. "  " .. icons.ui.Triangle .. " New File ", 
        "<CMD>ene!<CR>"
      ),
      button(
        "f", 
        icons.ui.FindFile .. "  " .. icons.ui.Triangle .. " Find File ", 
        "<CMD>Telescope find_files<CR>"
      ),
      button(
        "e", 
        icons.ui.FolderOpen .. "  " .. icons.ui.Triangle .. " Toggle file explorer ", 
        "<CMD>NvimTreeToggle<CR>"
      ),
      button(
        "t", 
        icons.ui.FindText .. "  " .. icons.ui.Triangle .. " Find Text ", 
        "<CMD>Telescope live_grep<CR>"
      ),
      button(
        "r", 
        icons.ui.Files .. "  " .. icons.ui.Triangle .. " Recent Files ", 
        "<CMD>Telescope oldfiles<CR>"
      ),
      button(
        "p", 
        icons.ui.Project .. "  " .. icons.ui.Triangle .. " Projects ", 
        "<CMD>Telescope Projects<CR>"
      ),
      button(
        "R", 
        icons.ui.History .. "  " .. icons.ui.Triangle .. " Restore Session For Current Directory ", 
        "<CMD>SessionRestore<CR>"
      ),
      button(
        "q", 
        icons.ui.Close .. "  " .. icons.ui.Triangle .. " Quit NVIM ", 
        "<CMD>qa<CR>"
      ),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

    -- set keymaps
    vim.keymap.set("n", "<leader>H", "<CMD>Alpha<CR>", { desc = "Dashboard" })
  end,
}
