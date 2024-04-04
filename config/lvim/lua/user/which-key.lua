-- file operations
lvim.builtin.which_key.mappings["f"] = { name = "+Files" }

-- quiting
lvim.builtin.which_key.mappings["q"] = { name = "+Quit" }

-- search
lvim.builtin.which_key.mappings["s"]["b"] = { }
lvim.builtin.which_key.mappings["/"] = lvim.builtin.which_key.mapping["s"]
lvim.builtin.which_key.mappings["s"] = {}

-- buffer operations
lvim.builtin.which_key.mappings["b"]["b"] = {}

-- remap plugins to capital p so that the panes can be lowercase p
lvim.builtin.which_key.mappings["w"] = { name = "+Windows" }

lvim.builtin.which_key.mappings["D"] = { name = "+Devcontainer" }

-- visual maps
lvim.builtin.which_key.vmappings["/"] = {} 
