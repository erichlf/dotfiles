config = function()
  return {
    on_config_done = nil,

    ---@usage set to true to disable setting the current-working directory
    --- Manual mode doesn't automatically change your root directory, so you have
    --- the option to manually do so using `:ProjectRoot` command.
    manual_mode = false,

    ---@usage Methods of detecting the root directory
    --- Allowed values: **"lsp"** uses the native neovim lsp
    --- **"pattern"** uses vim-rooter like glob pattern matching. Here
    --- order matters: if one is not detected, the other is used as fallback. You
    --- can also delete or rearangne the detection methods.
    -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
    detection_methods = { "pattern" },

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods
    patterns = { ".devcontainer", ".git" },

    -- Table of lsp clients to ignore by name
    -- eg: { "efm", ... }
    ignore_lsp = {},

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {},

    -- Show hidden files in telescope
    show_hidden = true,

    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = true,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = "global",
  }
end

function setup()
  local status_ok, project = pcall(require, "project_nvim")
  if not status_ok then
    return
  end

  configs = config()

  project.setup(configs)

  if configs.on_config_done then
    configs.on_config_done(project)
  end
end

return {
    "ahmedkhalf/project.nvim",
    config = function()
      setup()
    end,
    event = "VimEnter",
    cmd = "Telescope projects",
}

