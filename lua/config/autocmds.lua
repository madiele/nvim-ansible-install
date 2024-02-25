-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = { "*" },
  callback = function(ev)
    os.exit(0)
  end,
})
-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cs" },
  callback = function()
    vim.b.autoformat = false
  end,
})
