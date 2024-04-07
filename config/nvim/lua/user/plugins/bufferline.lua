return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  -- TODO: fix it so these don't break bufferline
  -- config = function() 
  --   -- helper for keymaps
  --   local function map(l, r, desc)
  --     vim.keymap.set("n", l, r, { desc = desc })
  --   end
  --   map("<leader><Tab>", "<CMD>edit #<CR>", "Previous Active Buffer")
  --   map("<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>", "Select Buffer 1")
  --   map("<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>", "Select Buffer 2")
  --   map("<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>", "Select Buffer 3")
  --   map("<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>", "Select Buffer 4")
  --   map("<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>", "Select Buffer 5")
  --   map("<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>", "Select Buffer 6")
  --   map("<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>", "Select Buffer 7")
  --   map("<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>", "Select Buffer 8")
  --   map("<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>", "Select Buffer 9")

  --   map("<leader>b<Left>", "<CMD>BufferLineCloseLeft<CR>", "Close All to Left")
  --   map("<leader>b<Right>", "<CMD>BufferLineCloseRight<CR>", "Close All to Right")
  --   map("<leader>b/", "<CMD>Telescope buffers previewer=false<CR>", "Find")
  --   map("<leader>bd", "<CMD>BufferKill<CR>", "Close")
  --   map("<leader>bD", "<CMD>BufferSortByDirectory<CR>", "Sort by Directory")
  --   map("<leader>bj", "<CMD>BufferLinePick<CR>", "Jump")
  --   map("<leader>bL", "<CMD>BufferLineSortByExtension<CR>", "Sort by Language")
  --   map("<leader>bp", "<CMD>BufferLineCyclePrev<CR>", "Previous")
  --   map("<leader>bn", "<CMD>BufferLineCycleNext<CR>", "next")
  -- end,
  opts = {
    options = {
      mode = "buffer",
      separator_style = "slant",
    },
  },
}
