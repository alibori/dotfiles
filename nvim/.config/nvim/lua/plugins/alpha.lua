return {
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        config = function()
            local dashboard = require("alpha.themes.dashboard")

            -- Generated from ~/Downloads/AxLiRoLOGOPNG.png
            local logo = {
                [[   ▄▄▄                ▄▄          ███     ▄▄▄▄▄▄▄]],
                [[  ▄████    ▄▄    ▄▄   ██        ▄▄▄▄▄     ██▀▀▀▀██     ▄▄]],
                [[  ██ ██    ▀██ ▄██▀   ██        ▀▀▀██     ██   ▄██  ▄██▀▀██▄]],
                [[ ███ ▄██     ███▀     ██           ██     ██████▀   ██    ██]],
                [[ ██▀▀▀██▄   ▄████▄    ██           ██     ██  ▀█▄   ██▄  ▄██]],
                [[██▀    ██  ██▀  ▀██   ████████  ████████  ██   ▀██   ▀████▀▀]],
            }

            -- The "x" (chars 10-20) is red like the logo; hl ranges are byte offsets
            local x_hl = {}
            for i, line in ipairs(logo) do
                x_hl[i] = { { "AlphaLogoX", #vim.fn.strcharpart(line, 0, 10), #vim.fn.strcharpart(line, 0, 20) } }
            end
            vim.api.nvim_set_hl(0, "AlphaLogoX", { link = "DiagnosticError" })

            dashboard.section.header.val = logo
            dashboard.section.header.opts.hl = x_hl
            dashboard.section.buttons.val = {
                dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
                dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("g", "  Grep", "<cmd>Telescope live_grep<CR>"),
                dashboard.button("e", "  Edit .env", "<cmd>e .env<CR>"),
                dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
                dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
            }

            -- One text element per link so alpha centers each line on its own
            local links = { type = "group", val = {} }
            for _, url in ipairs({
                "https://axliro.dev/",
                "https://github.com/alibori",
                "https://www.youtube.com/@axlirodev",
            }) do
                table.insert(links.val, { type = "text", val = url, opts = { position = "center", hl = "Comment" } })
            end
            table.insert(dashboard.config.layout, 3, { type = "padding", val = 1 })
            table.insert(dashboard.config.layout, 4, links)

            require("alpha").setup(dashboard.config)
        end,
    },
}
