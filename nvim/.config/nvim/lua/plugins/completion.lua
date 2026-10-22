return {
    {
        "saghen/blink.cmp",

        version = "1.*",

        dependencies = {
            "rafamadriz/friendly-snippets",
            "adalessa/laravel.nvim",
            "RicardoRamirezR/blade-nav.nvim",
        },

        opts = {
            keymap = {
                preset = "default",

                ["<C-space>"] = {
                    "show",
                    "show_documentation",
                    "hide_documentation",
                },

                ["<CR>"] = { "accept", "fallback" },

                ["<Tab>"] = {
                    "select_next",
                    "snippet_forward",
                    "fallback",
                },

                ["<S-Tab>"] = {
                    "select_prev",
                    "snippet_backward",
                    "fallback",
                },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    window = { border = "rounded" },
                },

                -- Off: copilot.vim already renders inline ghost text
                ghost_text = {
                    enabled = false,
                },

                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },

                menu = {
                    border = "rounded",

                    draw = {
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
            },

            fuzzy = {
                sorts = { "score", "sort_text" },
            },

            signature = {
                enabled = true,
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "laravel",
                    "blade-nav",
                },

                providers = {
                    laravel = {
                        name = "laravel",
                        module = "laravel.extensions.completion.blink",
                        score_offset = 90,
                    },
                    ["blade-nav"] = {
                        name = "BladeNav",
                        module = "blade-nav.integrations.blink",
                        score_offset = 85,
                    },
                },
            },
        },

        opts_extend = {
            "sources.default",
        },
    },
}
