return {
	{
		"L3MON4D3/LuaSnip",
		keys = function()
			-- Disable default tab keybinding in LuaSnip
			return {}
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require "cmp"
			local lspkind = require "lspkind"
			local luasnip = require "luasnip"
			local ELLIPSIS_CHAR = "…"
			local MAX_LABEL_WIDTH = 20
			local MIN_LABEL_WIDTH = 20

			cmp.setup {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				window = {
					completion = cmp.config.window.bordered {
						scrollbar = false,
					},
					documentation = cmp.config.window.bordered {
						scrollbar = false,
					},
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path", option = {
						trailing_slash = true,
					} },
				},
				mapping = cmp.mapping.preset.insert {
					["<C-e>"] = cmp.mapping(function()
						return vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<C-o>A", true, true, true),
							"n",
							true
						)
					end),

					["<C-s>"] = cmp.mapping {
						i = cmp.mapping.confirm { select = true },
						c = cmp.mapping.confirm { select = true },
					},
					["<M-s>"] = cmp.mapping {
						i = cmp.mapping.confirm { select = true },
						c = cmp.mapping.confirm { select = true },
					},

					["<Tab>"] = cmp.mapping {
						c = cmp.mapping.confirm { select = true },
						i = cmp.mapping.confirm { select = true },
					},
					["<M-r>"] = cmp.mapping {
						i = cmp.mapping.close(),
						c = cmp.mapping.close(),
					},

					-- ["<C-u>"] = cmp.mapping.scroll_docs(-4),
					-- ["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-d>"] = cmp.mapping {
						i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
						c = cmp.mapping.select_next_item {
							-- behavior = cmp.SelectBehavior.Insert,
							behavior = cmp.SelectBehavior.Select,
						},
					},
					["<C-q>"] = cmp.mapping {
						i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
						c = cmp.mapping.select_prev_item {
							-- behavior = cmp.SelectBehavior.Insert,
							behavior = cmp.SelectBehavior.Select,
						},
					},
					["<C-j>"] = cmp.mapping {
						i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
						c = cmp.mapping.select_next_item {
							-- behavior = cmp.SelectBehavior.Insert,
							behavior = cmp.SelectBehavior.Select,
						},
					},
					["<C-k>"] = cmp.mapping {
						i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
						c = cmp.mapping.select_prev_item {
							-- behavior = cmp.SelectBehavior.Insert,
							behavior = cmp.SelectBehavior.Select,
						},
					},

					["<M-j>"] = cmp.mapping {
						i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
						c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
					},
					["<M-k>"] = cmp.mapping {

						i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
						c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
					},
				},

				snippet = {
					expand = function(args)
						-- vim.snippet.expand(args.body)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					format = function(entry, vim_item)
						-- Apply lspkind formatting
						vim_item = lspkind.cmp_format {
							mode = "symbol_text",
						}(entry, vim_item)

						-- Apply custom label truncation
						local label = vim_item.abbr
						local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
						if truncated_label ~= label then
							vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
						elseif string.len(label) < MIN_LABEL_WIDTH then
							local padding = string.rep(" ", MIN_LABEL_WIDTH - string.len(label))
							vim_item.abbr = label .. padding
						end

						return vim_item
					end,
				},
			}

			local cmdline_mappings = cmp.mapping.preset.cmdline {
				["<M-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
				["<M-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },

				["<M-s>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
				["<C-d>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
				["<C-q>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
				["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
				["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
				["<C-s>"] = cmp.mapping.confirm { select = true, behavior = cmp.ConfirmBehavior.Insert },
				["<M-r>"] = cmp.mapping.close(),
				-- ["<C-r>"] = cmp.mapping.abort(), -- Cancel completion
				["<Tab>"] = cmp.mapping.confirm { select = true },
			}
			-- `/` cmdline setup
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmdline_mappings,
				sources = {
					{ name = "path", option = {
						trailing_slash = true,
					} },
					{ name = "buffer" },
				},
				-- completion = {
				--   completeopt = "menu,noselect",
				-- },
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmdline_mappings,
				sources = cmp.config.sources({
					{
						name = "path",
						-- option = {
						--   trailing_slash = true, -- set false for non directory slash
						-- },
					},
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},
}
