return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		ensure_installed = {},
	},
---@diagnostic disable-next-line: unused-local
  config = function (plugin)
    require 'nvim-treesitter.install'.compilers = { "clang" }
  end
}
