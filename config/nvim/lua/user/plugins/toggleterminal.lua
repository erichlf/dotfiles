local  configs = {
  on_config_done = nil,
  -- size can be a number or function which is passed the current terminal
  size = 20,
  open_mapping = [[<c-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
  direction = "float",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = nil, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    border = "curved",
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  -- Add executables on the config.lua
  -- { cmd, keymap, description, direction, size }
  execs = {
    { nil, "<M-1>", "Horizontal Terminal", "horizontal", 0.3 },
    { nil, "<M-2>", "Vertical Terminal", "vertical", 0.4 },
    { nil, "<M-3>", "Float Terminal", "float", nil },
  },
}

--- Get current buffer size
---@return {width: number, height: number}
local function get_buf_size()
  local cbuf = vim.api.nvim_get_current_buf()
  local bufinfo = vim.tbl_filter(function(buf)
    return buf.bufnr == cbuf
  end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
  if bufinfo == nil then
    return { width = -1, height = -1 }
  end
  return { width = bufinfo.width, height = bufinfo.height }
end

--- Get the dynamic terminal size in cells
---@param direction number
---@param size number
---@return integer
local function get_dynamic_terminal_size(direction, size)
  size = size or configs.size
  if direction ~= "float" and tostring(size):find(".", 1, true) then
    size = math.min(size, 1.0)
    local buf_sizes = get_buf_size()
    local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
    return buf_size * size
  else
    return size
  end
end

add_exec = function(opts)
  local binary = opts.cmd:match "(%S+)"
  if vim.fn.executable(binary) ~= 1 then
    return
  end

  vim.keymap.set({ "n", "t" }, opts.keymap, function()
    _exec_toggle { cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() }
  end, { desc = opts.label, noremap = true, silent = true })
end

_exec_toggle = function(opts)
  local Terminal = require("toggleterm.terminal").Terminal
  local term = Terminal:new { cmd = opts.cmd, count = opts.count, direction = opts.direction }
  term:toggle(opts.size, opts.direction)
end

init = function()
  for i, exec in pairs(configs.execs) do
    local direction = exec[4] or configs.direction

    local opts = {
      cmd = exec[1] or configs.shell or vim.o.shell,
      keymap = exec[2],
      label = exec[3],
      count = i + 100,
      direction = direction,
      size = function()
        return get_dynamic_terminal_size(direction, exec[5])
      end,
    }

    add_exec(opts)
  end
end

setup = function()
  local terminal = require "toggleterm"
  terminal.setup(configs)
end

return {
  "akinsho/toggleterm.nvim",
  branch = "main",
  init = function()
    init()
  end,
  config = function()
    setup()
  end,
  cmd = {
    "ToggleTerm",
    "TermExec",
    "ToggleTermToggleAll",
    "ToggleTermSendCurrentLine",
    "ToggleTermSendVisualLines",
    "ToggleTermSendVisualSelection",
  },
}

