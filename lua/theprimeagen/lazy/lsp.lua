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
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
                "vtsls",
                "vue_ls",
            },
            automatic_installation = false,
        })

        local lspconfig = require("lspconfig")

        -- ===== Manual ZLS Setup =====
        lspconfig.zls.setup({
            cmd = { "zls" }, -- or absolute path if needed
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            capabilities = capabilities,
            settings = {
                zls = {
                    semantic_tokens = "partial",
                    enable_inlay_hints = true,
                    enable_snippets = false,
                    warn_style = true,
                    zig_exe_path = '/Users/james/.cache/zig/p/N-V-__8AAMqPphXR-hd8QdQgX72usgPQp7r48DnmlhYirfOm/zig'
                },
            },
            on_attach = function(client, bufnr)
                vim.g.zig_fmt_parse_errors = 0
                vim.g.zig_fmt_autosave = 0

                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = vim.api.nvim_create_augroup("ZigLspFormat", { clear = true }),
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end,
        })
        -- =============================

        -- ===== Lua LSP =====
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    },
                },
            },
        })

        -- ===== Completion =====
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
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
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            }),
            formatting = {
                fields = { "abbr", "kind" }, -- hide "menu"
                format = function(entry, item)
                    item.menu = nil          -- no source labels
                    item.detail = nil        -- REMOVE TYPE/SIGNATURE INFO
                    return item
                end,
            },
        })

        -- ===== Diagnostics =====
        vim.diagnostic.config({
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
