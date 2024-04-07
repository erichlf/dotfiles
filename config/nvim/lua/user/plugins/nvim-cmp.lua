config = function()
  local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
  if not status_cmp_ok then
    return
  end
  local ConfirmBehavior = cmp_types.ConfirmBehavior
  local SelectBehavior = cmp_types.SelectBehavior

  -- local cmp = require("lvim.utils.modules").require_on_index "cmp"
  -- local luasnip = require("lvim.utils.modules").require_on_index "luasnip"
  local cmp_window = require "cmp.config.window"
  local cmp_mapping = require "cmp.config.mapping"

  local icons = require("user.core.icons")

  return {
    active = true,
    on_config_done = nil,
    enabled = function()
      local buftype = vim.api.nvim_buf_get_option(0, "buftype")
      if buftype == "prompt" then
        return false
      end
      return configs.active
    end,
    confirm_opts = {
      behavior = ConfirmBehavior.Replace,
      select = false,
    },
    completion = {
      ---@usage The minimum length of a word to complete on.
      keyword_length = 1,
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      max_width = 0,
      kind_icons = icons.kind,
      source_names = {
        nvim_lsp = "(LSP)",
        emoji = "(Emoji)",
        path = "(Path)",
        calc = "(Calc)",
        cmp_tabnine = "(Tabnine)",
        vsnip = "(Snippet)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
        tmux = "(TMUX)",
        copilot = "(Copilot)",
        treesitter = "(TreeSitter)",
      },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      },
      duplicates_default = 0,
      format = function(entry, vim_item)
        local max_width = configs.formatting.max_width
        if max_width ~= 0 and #vim_item.abbr > max_width then
          vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
        end
        vim_item.kind = configs.formatting.kind_icons[vim_item.kind]

        if entry.source.name == "copilot" then
          vim_item.kind = icons.git.Octoface
          vim_item.kind_hl_group = "CmpItemKindCopilot"
        end

        if entry.source.name == "cmp_tabnine" then
          vim_item.kind = icons.misc.Robot
          vim_item.kind_hl_group = "CmpItemKindTabnine"
        end

        if entry.source.name == "crates" then
          vim_item.kind = icons.misc.Package
          vim_item.kind_hl_group = "CmpItemKindCrate"
        end

        if entry.source.name == "lab.quick_data" then
          vim_item.kind = icons.misc.CircuitBoard
          vim_item.kind_hl_group = "CmpItemKindConstant"
        end

        if entry.source.name == "emoji" then
          vim_item.kind = icons.misc.Smiley
          vim_item.kind_hl_group = "CmpItemKindEmoji"
        end
        vim_item.menu = configs.formatting.source_names[entry.source.name]
        vim_item.dup = configs.formatting.duplicates[entry.source.name]
          or configs.formatting.duplicates_default
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp_window.bordered(),
      documentation = cmp_window.bordered(),
    },
    sources = {
      {
        name = "copilot",
        -- keyword_length = 0,
        max_item_count = 3,
        trigger_characters = {
          {
            ".",
            ":",
            "(",
            "'",
            '"',
            "[",
            ",",
            "#",
            "*",
            "@",
            "|",
            "=",
            "-",
            "{",
            "/",
            "\\",
            "+",
            "?",
            " ",
            -- "\t",
            -- "\n",
          },
        },
      },
      {
        name = "nvim_lsp",
        entry_filter = function(entry, ctx)
          local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
          if kind == "Snippet" and ctx.prev_context.filetype == "java" then
            return false
          end
          return true
        end,
      },

      { name = "path" },
      { name = "luasnip" },
      { name = "cmp_tabnine" },
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "calc" },
      { name = "emoji" },
      { name = "treesitter" },
      { name = "crates" },
      { name = "tmux" },
    },
    mapping = cmp_mapping.preset.insert {
      ["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
      ["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
      ["<Down>"] = cmp_mapping(cmp_mapping.select_next_item { behavior = SelectBehavior.Select }, { "i" }),
      ["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item { behavior = SelectBehavior.Select }, { "i" }),
      ["<C-d>"] = cmp_mapping.scroll_docs(-4),
      ["<C-f>"] = cmp_mapping.scroll_docs(4),
      ["<C-y>"] = cmp_mapping {
        i = cmp_mapping.confirm { behavior = ConfirmBehavior.Replace, select = false },
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = ConfirmBehavior.Replace, select = false }
          else
            fallback()
          end
        end,
      },
      ["<Tab>"] = cmp_mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif jumpable(1) then
          luasnip.jump(1)
        elseif has_words_before() then
          -- cmp.complete()
          fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp_mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Space>"] = cmp_mapping.complete(),
      ["<C-e>"] = cmp_mapping.abort(),
      ["<CR>"] = cmp_mapping(function(fallback)
        if cmp.visible() then
          local confirm_opts = vim.deepcopy(configs.confirm_opts) -- avoid mutating the original opts below
          local is_insert_mode = function()
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end
          if is_insert_mode() then -- prevent overwriting brackets
            confirm_opts.behavior = ConfirmBehavior.Insert
          end
          local entry = cmp.get_selected_entry()
          local is_copilot = entry and entry.source.name == "copilot"
          if is_copilot then
            confirm_opts.behavior = ConfirmBehavior.Replace
            confirm_opts.select = true
          end
          if cmp.confirm(confirm_opts) then
            return -- success, exit early
          end
        end
        fallback() -- if not exited early, always fallback
      end),
    },
    cmdline = {
      enable = false,
      options = {
        {
          type = ":",
          sources = {
            { name = "path" },
            { name = "cmdline" },
          },
        },
        {
          type = { "/", "?" },
          sources = {
            { name = "buffer" },
          },
        },
      },
    },
  }
end

function setup()
  local cmp = require "cmp"

  configs = config()

  cmp.setup(configs)

  if configs.cmdline.enable then
    for _, option in ipairs(configs.cmdline.options) do
      cmp.setup.cmdline(option.type, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = option.sources,
      })
    end
  end

  if configs.on_config_done then
    configs.on_config_done(cmp)
  end
end

return {
  "hrsh7th/nvim-cmp",
  config = function()
    setup()
  end,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "cmp-nvim-lsp",
    "cmp_luasnip",
    "cmp-buffer",
    "cmp-path",
    "cmp-cmdline",
  },
}
