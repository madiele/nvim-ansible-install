return {
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keymaps = require("lazyvim.plugins.lsp.keymaps")
			local keys = keymaps.get()
			keys[#keys + 1] = { "gd", vim.lsp.buf.definition, desc = "Goto Definition" }
			keys[#keys + 1] = { "gn", vim.lsp.buf.incoming_calls, desc = "Incoming Calls" }
			keys[#keys + 1] = { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" }
			keys[#keys + 1] = { "gt", vim.lsp.buf.type_definition, desc = "Goto Type Definition" }
			keys[#keys + 1] = { "gl", vim.lsp.codelens.run, desc = "Run codelens" }
			keys[#keys + 1] = { "gR", vim.lsp.buf.rename, desc = "Rename Symbol" }
			keys[#keys + 1] = { "gk", vim.lsp.buf.signature_help, desc = "Signature Help" }
			keys[#keys + 1] = { "ga", vim.lsp.buf.code_action, desc = "Code Action" }
			keys[#keys + 1] = { "<leader>lk", vim.lsp.buf.hover, desc = "Hover Symbol" }
		end,
	},
}
