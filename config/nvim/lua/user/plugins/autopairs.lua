return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = { 
    "nvim-treesitter/nvim-treesitter", 
    "hrsh7th/nvim-cmp" 
  },
  config = function()
    -- import nvim-autopairs
    local autopairs = require("nvim-autopairs")

    -- configure autopairs
    autopairs.setup(
      {
        check_ts = true, -- enable treesitter
        enable_check_bracket_line = false,
        ts_config = {
          lua = { "string", "source" }, -- don't add pairs in lua string treesitter nodes
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        disable_in_macro= false,
        enable_after_quote = true,
        map_bs = true,
        map_c_w = false,
        disable_in_visualblock = false,
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          offset = 0, -- Offset from pattern match
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      }
    )

    -- import nvim-autopairs completion functionality
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- import nvim-cmp plugin (completions plugin)
    local cmp = require("cmp")

    -- make autopairs and completion work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

