return {
	-- "ofirgall/ofirkai.nvim",
	-- "catppuccin/nvim",
    "rose-pine/neovim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("rose-pine")
		require("rose-pine").setup({
			scheme = require("rose-pine").scheme, -- Option to override scheme
			custom_hlgroups = {}, -- Option to add/override highlight groups
			remove_italics = false, -- Option to change all the italics style to none
		})

		function ColourMyPencils(color)
			color = "rose-pine"
			vim.cmd.colorscheme(color)

			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end

		ColourMyPencils()
	end,
}
