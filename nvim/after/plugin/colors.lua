require('ofirkai').setup {
	scheme = require('ofirkai').scheme, -- Option to override scheme
	custom_hlgroups = {},              -- Option to add/override highlight groups
	remove_italics = false,            -- Option to change all the italics style to none
}

function ColourMyPencils(color)
	color = color or "ofirkai"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColourMyPencils()
