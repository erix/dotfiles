---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>gs"] = { ":LazyGitCurrentFile <CR>", "git status (LazyGit)" },
  },
}

-- more keybinds!

return M
