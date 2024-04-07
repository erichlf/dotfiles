return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

    -- helper for keymaps
    local function map(l, r, desc)
      vim.keymap.set("n", l, r, { desc = desc })
    end

    map("<leader>pr", "<cmd>SessionRestore<CR>", "Restore Session") -- restore last workspace session for current directory
    map("<leader>ps", "<cmd>SessionSave<CR>", "Save Session") -- save workspace session for current working directory
  end,
}
