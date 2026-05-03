return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.textDocument.completion.completionItem = {
			documentationFormat = { "markdown", "plaintext" },
			snippetSupport = true,
			preselectSupport = true,
			insertReplaceSupport = true,
			labelDetailsSupport = true,
			deprecatedSupport = true,
			commitCharactersSupport = true,
			tagSupport = { valueSet = { 1 } },
			resolveSupport = {
				properties = {
					"documentation",
					"detail",
					"additionalTextEdits",
				},
			},
		}

		local ok, blink = pcall(require, "blink.cmp")
		if ok then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		local function get_vue_plugin_path()
			if require("nixCatsUtils").isNixCats then
				local exe = vim.fn.exepath("vue-language-server")
				if exe ~= "" then
					return vim.fn.glob(vim.fs.dirname(exe) .. "/../lib/**/@vue/typescript-plugin", true, true)[1]
				end
			end
			return vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
		end

		local function setup_servers()
			local vue_plugin = {
				name = "@vue/typescript-plugin",
				location = get_vue_plugin_path() or "",
				languages = { "vue" },
				configNamespace = "typescript",
			}

			local servers = {
				html = {
					filetypes = { "html", "ejs", "php" },
					capabilities = capabilities,
				},

				cssls = { capabilities = capabilities },

				emmet_ls = {
					filetypes = { "html", "javascript", "markdown", "php" },
					capabilities = capabilities,
				},

				vtsls = {
					filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
					root_markers = {
						"tsconfig.json",
						"package.json",
						"jsconfig.json",
						".git",
						".envrc",
					},
					settings = {
						vtsls = {
							tsserver = {
								globalPlugins = { vue_plugin },
							},
						},
					},
					capabilities = capabilities,
				},

				vue_ls = { capabilities = capabilities },

				intelephense = {
					capabilities = capabilities,
					settings = {
						intelephense = {
							stubs = {
								"apache",
								"bcmath",
								"bz2",
								"calendar",
								"com_dotnet",
								"Core",
								"ctype",
								"curl",
								"date",
								"dba",
								"dom",
								"enchant",
								"exif",
								"FFI",
								"fileinfo",
								"filter",
								"fpm",
								"ftp",
								"gd",
								"gettext",
								"gmp",
								"hash",
								"iconv",
								"imap",
								"intl",
								"json",
								"ldap",
								"libxml",
								"mbstring",
								"meta",
								"mysqli",
								"oci8",
								"odbc",
								"openssl",
								"pcntl",
								"pcre",
								"PDO",
								"pdo_ibm",
								"pdo_mysql",
								"pdo_pgsql",
								"pdo_sqlite",
								"pgsql",
								"Phar",
								"posix",
								"pspell",
								"readline",
								"Reflection",
								"session",
								"shmop",
								"SimpleXML",
								"snmp",
								"soap",
								"sockets",
								"sodium",
								"SPL",
								"sqlite3",
								"standard",
								"superglobals",
								"sysvmsg",
								"sysvsem",
								"sysvshm",
								"tidy",
								"tokenizer",
								"xml",
								"xmlreader",
								"xmlrpc",
								"xmlwriter",
								"xsl",
								"Zend OPcache",
								"zip",
								"zlib",
								"wordpress",
								"laravel",
								"blade",
							},
						},
					},
				},

				gopls = {
					capabilities = capabilities,
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},

				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							checkOnSave = {
								command = "clippy",
							},
						},
					},
					capabilities = capabilities,
				},

				tailwindcss = {
					on_attach = function(client)
						client.server_capabilities.documentColorProvider = false
					end,
					filetypes = {
						"html",
						"css",
						"scss",
						"javascriptreact",
						"typescriptreact",
						"vue",
					},
					root_markers = { "tailwind.config.js", "tailwind.config.ts" },
					capabilities = capabilities,
				},

				cmake = { capabilities = capabilities },

				clangd = {
					filetypes = { "c", "cpp" },
					cmd = { "clangd", "--compile-commands-dir=." },
					capabilities = capabilities,
					init_options = {
						clangdFileStatus = true,
						inlayHints = {
							enable = true,
							parameterNames = true,
							parameterTypes = true,
							variableTypes = true,
						},
					},
				},

				nixd = {
					capabilities = capabilities,
					on_attach = function(client)
						client.server_capabilities.codeActionProvider = nil
						client.server_capabilities.definitionProvider = false
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentSymbolProvider = false
						client.server_capabilities.documentHighlightProvider = false
						client.server_capabilities.hoverProvider = false
						client.server_capabilities.inlayHintProvider = false
						client.server_capabilities.referencesProvider = false
						client.server_capabilities.renameProvider = false
					end,
				},

				["nil"] = {
					on_attach = function(client)
						client.server_capabilities.completionProvider = nil
					end,
					cmd = { vim.fn.exepath("nil") },
					capabilities = capabilities,
					filetypes = { "nix" },
				},

				lua_ls = {
					filetypes = { "lua" },
					capabilities = capabilities,
					settings = {
						Lua = {
							hint = {
								enable = true,
							},
							diagnostics = {
								globals = {
									"vim",
									"require",
									"Snacks",
									"Laravel",
									"state",
								},
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},

				roslyn = {
					settings = {
						["csharp|inlay_hints"] = {
							csharp_enable_inlay_hints_for_implicit_object_creation = true,
							csharp_enable_inlay_hints_for_implicit_variable_types = true,
						},
						["csharp|code_lens"] = {
							dotnet_enable_references_code_lens = true,
						},
					},
					capabilities = capabilities,
				},

				bashls = { capabilities = capabilities },

				marksman = { capabilities = capabilities },

				jsonls = { capabilities = capabilities },

				pyright = { capabilities = capabilities },

				qmlls = {
					capabilities = capabilities,
					handlers = {
						["textDocument/publishDiagnostics"] = function(err, method, params, client_id)
							local filtered_diagnostics = {}
							for _, diagnostic in ipairs(method.diagnostics) do
								if diagnostic.severity ~= vim.diagnostic.severity.WARN then
									table.insert(filtered_diagnostics, diagnostic)
								end
							end

							method.diagnostics = filtered_diagnostics
							vim.lsp.handlers["textDocument/publishDiagnostics"](err, method, params, client_id)
						end,
					},
				},

				jdtls = { capabilities = capabilities },
			}

			vim.api.nvim_create_autocmd("User", {
				pattern = "DirenvLoaded",
				callback = function()
					vim.cmd("silent! lsp restart")
				end,
			})

			for server, config in pairs(servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end

		setup_servers()
	end,
}
