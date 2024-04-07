return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map("n", "]h", gitsigns.next_hunk, "Next Hunk")
      map("n", "[h", gitsigns.prev_hunk, "Prev Hunk")

      -- Actions
      map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
      map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
      map(
        "v", 
        "<leader>gs", 
        function() 
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) 
        end, 
        "Stage hunk"
      )
      map(
        "v", 
        "<leader>gr", 
        function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, 
        "Reset hunk"
      )

      map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
      map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")

      map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")

      map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")

      -- map(
      --   "n", 
      --   "<leader>gb", 
      --   function() 
      --     gitsigns.blame_line({ full = true }) 
      --   end, 
      --   "Blame line"
      -- )
      map("n", "<leader>gB", gitsigns.toggle_current_line_blame, "Toggle Line Blame")
      map("n", "<leader>gd", gitsigns.diffthis, "Diff This")
      map(
        "n", 
        "<leader>gD", 
        function() 
          gitsigns.diffthis("~") 
        end, 
        "Diff This ~")

      map("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", "Checkout branch")
      map("n", "<leader>gc", "<CMD>Telescope git_commits<CR>", "Checkout commit")
      map("n", "<leader>gC", "<CMD>Telescope git_bcommits<CR>", "Checkout commit(for current file)")
      map("n", "<leader>go", "<CMD>Telescope git_status<CR>", "Open changed file")

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
    end,
  },
}
