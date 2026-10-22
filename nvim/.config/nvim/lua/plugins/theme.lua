return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            -- Plugin integrations are auto-detected from lazy.nvim (auto_integrations)
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = false,

                -- Dim unfocused splits so the active window stands out
                dim_inactive = { enabled = true, percentage = 0.1 },

                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    keywords = { "italic" },
                    types = { "bold" },
                },

                lsp_styles = {
                    underlines = {
                        errors = { "undercurl" },
                        warnings = { "undercurl" },
                        hints = { "underline" },
                        information = { "underline" },
                    },
                },

                custom_highlights = function(c)
                    return {
                        -- $this / self stand out
                        ["@variable.builtin"] = { fg = c.red, style = { "italic" } },
                        -- PHPDoc tags (@param, @return) stand out inside comments
                        ["@keyword.phpdoc"] = { fg = c.mauve, style = { "italic" } },
                        -- Blade directives (@if, @foreach)
                        ["@tag.blade"] = { fg = c.pink },
                        -- Visible separator between splits
                        WinSeparator = { fg = c.surface1 },
                    }
                end,
            })

            vim.cmd.colorscheme("catppuccin-mocha")
        end,
    },
}
