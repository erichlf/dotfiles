-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Apply LSP formatting safely when the buffer changes
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("LspBufferFormat", { clear = true }),
  pattern = "*",
  callback = function(args)
    -- Check if there is an active LSP client attached to the buffer first
    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    if #clients > 0 then
      vim.lsp.buf.format({ bufnr = args.buf, async = false })
    end
  end,
})
