return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            -- Map the pywal palette (~/.cache/wal/colors.json) onto catppuccin's
            -- slots; plain mocha if wal has never run. red/yellow stay catppuccin so
            -- errors/warnings keep contrast on desaturated palettes.
            local function wal_palette()
                local f = io.open(vim.fn.expand("~/.cache/wal/colors.json"))
                if not f then
                    return {}
                end
                local wal = vim.json.decode(f:read("*a"))
                f:close()
                local c, bg, fg = wal.colors, wal.special.background, wal.special.foreground
                local blend = require("catppuccin.utils.colors").blend
                local mix = function(a) return blend(fg, bg, a) end
                local shade = function(a) return blend("#000000", bg, a) end
                return {
                    rosewater = c.color15, flamingo = c.color13, pink = c.color13, mauve = c.color5,
                    maroon = c.color9, peach = c.color9,
                    green = c.color2, teal = c.color6, sky = c.color14, sapphire = c.color12,
                    blue = c.color4, lavender = c.color12,
                    text = fg, subtext1 = mix(0.85), subtext0 = mix(0.7),
                    overlay2 = mix(0.6), overlay1 = mix(0.5), overlay0 = mix(0.4),
                    surface2 = mix(0.3), surface1 = mix(0.2), surface0 = mix(0.1),
                    base = bg, mantle = shade(0.2), crust = shade(0.35),
                }
            end

            local function apply()
                -- Plugin integrations are auto-detected from lazy.nvim (auto_integrations)
                require("catppuccin").setup({
                    flavour = "mocha",
                    color_overrides = { mocha = wal_palette() },
                    transparent_background = true,

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
            end

            apply()
            -- Called by ~/.config/wal/apply.sh on every palette change
            vim.api.nvim_create_user_command("WalReload", apply, {})
        end,
    },
}
