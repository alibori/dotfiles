return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "intelephense",
                    "phpactor",
                    "lua_ls",
                    "html",
                    "cssls",
                    "jsonls",
                    "ts_ls",
                    "tailwindcss",
                    "emmet_ls",
                },
                automatic_enable = false,
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Merge nvim-lsp-file-operations caps so phpactor receives
            -- workspace/willRenameFiles → renaming a file in nvim-tree renames the
            -- class + all usages (PhpStorm parity). phpactor only: intelephense
            -- needs a premium licence for this, and one server avoids duplicate edits.
            local file_op_capabilities = vim.tbl_deep_extend(
                "force",
                capabilities,
                require("lsp-file-operations").default_capabilities()
            )

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local bufnr = event.buf

                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, {
                            buffer = bufnr,
                            desc = desc,
                        })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    -- `gr` would shadow 0.11 defaults (grr/grn/gra/gri) and wait timeoutlen
                    map("n", "gR", vim.lsp.buf.references, "References")
                    map("n", "gi", vim.lsp.buf.implementation, "Implementation")
                    map("n", "K", function()
                        vim.lsp.buf.hover({ border = "rounded" })
                    end, "Documentation")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Diagnostic")
                    map("n", "[d", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, "Previous diagnostic")
                    map("n", "]d", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, "Next diagnostic")
                end,
            })

            vim.lsp.config("intelephense", {
                capabilities = capabilities,
                -- Rename is premium: without a licence intelephense advertises it but
                -- returns nothing, shadowing phpactor. Remove this if you buy a licence.
                on_init = function(client)
                    client.server_capabilities.renameProvider = nil
                end,
                settings = {
                    intelephense = {
                        files = {
                            maxSize = 5000000,
                        },
                        completion = {
                            -- Auto-add `use` statement when accepting a class (PhpStorm parity)
                            insertUseDeclaration = true,
                            fullyQualifyGlobalConstantsAndFunctions = false,
                            suggestObjectOperatorStaticMethods = true,
                            maxItems = 100,
                        },
                        format = {
                            -- User formats via scripts (pint) — keep LSP format off by default
                            enable = false,
                        },
                    },
                },
            })

            -- phpactor runs alongside intelephense, kept for code actions, rename,
            -- file-rename refactors (<leader>pa, <leader>rn) and the navigation that
            -- free intelephense lacks (implementation, declaration, type definition).
            -- Everything intelephense already answers is stripped to avoid duplicates.
            vim.lsp.config("phpactor", {
                cmd = { "phpactor", "language-server" },
                filetypes = { "php" },
                root_markers = { "composer.json", ".git" },
                capabilities = file_op_capabilities,
                handlers = {
                    ["textDocument/publishDiagnostics"] = function() end,
                },
                on_init = function(client)
                    local caps = client.server_capabilities
                    for _, cap in ipairs({
                        "completionProvider",
                        "hoverProvider",
                        "definitionProvider",
                        "referencesProvider",
                        "documentSymbolProvider",
                        "workspaceSymbolProvider",
                        "signatureHelpProvider",
                        "documentHighlightProvider",
                        "documentFormattingProvider",
                        "documentRangeFormattingProvider",
                    }) do
                        caps[cap] = nil
                    end
                end,
            })

            -- Official Laravel LSP (composer global require laravel/lsp).
            -- Laravel-aware routes/views/config/env completion + diagnostics.
            vim.lsp.config("laravel_lsp", {
                cmd = { "laravel-lsp" },
                filetypes = { "php", "blade" },
                root_markers = { "artisan", "composer.json", ".git" },
                capabilities = capabilities,
            })

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            vim.lsp.config("html", {
                capabilities = capabilities,
            })

            vim.lsp.config("cssls", {
                capabilities = capabilities,
            })

            vim.lsp.config("jsonls", {
                capabilities = capabilities,
            })

            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
            })

            vim.lsp.config("tailwindcss", {
                capabilities = capabilities,
                filetypes = {
                    "html", "blade", "php",
                    "javascript", "javascriptreact",
                    "typescript", "typescriptreact",
                    "css",
                },
                settings = {
                    tailwindCSS = {
                        includeLanguages = {
                            blade = "html",
                            php = "html",
                        },
                    },
                },
            })

            vim.lsp.config("emmet_ls", {
                capabilities = capabilities,
                filetypes = { "html", "blade", "css", "javascript", "typescript" },
            })

            vim.lsp.enable({
                "intelephense",
                "phpactor",
                "laravel_lsp",
                "lua_ls",
                "html",
                "cssls",
                "jsonls",
                "ts_ls",
                "tailwindcss",
                "emmet_ls",
            })
        end,
    },
}
