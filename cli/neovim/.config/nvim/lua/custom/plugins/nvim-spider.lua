return {
	"chrisgrieser/nvim-spider",
	enabled = true,
	lazy = true,
	opts = {
		skipInsignificantPunctuation = false,
		consistentOperatorPending = false,
		subwordMovement = true,
	},
	keys = {
		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
		},
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
		},
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
		},
	},
}
