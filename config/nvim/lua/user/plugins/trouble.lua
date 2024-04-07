return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  keys = {
    { "<leader>Td", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open Trouble Document Diagnostics" },
    { "<leader>Tl", "<cmd>TroubleToggle loclist<CR>", desc = "Open Trouble Location List" },
    { "<leader>Tq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open Trouble Quickfix List" },
    { "<leader>Tt", "<cmd>TodoTrouble<CR>", desc = "Open TODOs in Trouble" },
    { "<leader>TT", "<cmd>TroubleToggle<CR>", desc = "Open/Close Trouble List" },
    { "<leader>Tw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Open Trouble Workspace Diagnostics" },
  },
}
