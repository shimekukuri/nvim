return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()

        -- Define servers configuration (you can add more servers here)
        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = "Lua 5.1" },
                        diagnostics = {
                            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                        }
                    }
                }
            },
            zls = {
                root_dir = require("lspconfig").util.root_pattern(".git", "build.zig", "zls.json"),
                settings = {
                    zls = {
                        enable_inlay_hints = true,
                        enable_snippets = true,
                        warn_style = true,
                    },
                },
                on_attach = function()
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,
            }
        }

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "vtsls",
                "vue_ls",
            },
            automatic_installation = false,
            handlers = {
                function(server_name) -- default handler
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            }
        })

        -- Vue.js and TypeScript configuration
        local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
        '/vue-language-server' .. '/node_modules/@vue/language-server'
        local vue_plugin = {
            name = '@vue/typescript-plugin',
            location = vue_language_server_path,
            languages = { 'vue' },
            configNamespace = 'typescript',
        }

        local vtsls_config = {
            settings = {
                vtsls = {
                    tsserver = {
                        globalPlugins = {
                            vue_plugin,
                        },
                    },
                },
            },
            filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
        }

        local vue_ls_config = {
            on_init = function(client)
                client.handlers['tsserver/request'] = function(_, result, context)
                    local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
                    if #clients == 0 then
                        vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.',
                            vim.log.levels.ERROR)
                        return
                    end
                    local ts_client = clients[1]
                    local param = unpack(result)
                    local id, command, payload = unpack(param)
                    ts_client:exec_cmd({
                        title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
                        command = 'typescript.tsserverRequest',
                        arguments = {
                            command,
                            payload,
                        },
                    }, { bufnr = context.bufnr }, function(_, r)
                        local response = r and r.body
                        -- TODO: handle error or response nil here, e.g. logging
                        -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
                        local response_data = { { id, response } }
                        ---@diagnostic disable-next-line: param-type-mismatch
                        client:notify('tsserver/response', response_data)
                    end)
                end
            end,
        }

        -- nvim 0.11 or above Vue.js configuration
        vim.lsp.config('vtsls', vtsls_config)
        vim.lsp.config('vue_ls', vue_ls_config)
        vim.lsp.enable { 'vtsls', 'vue_ls' }

        -- Completion setup
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
