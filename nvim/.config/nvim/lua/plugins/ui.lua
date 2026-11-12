return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                },
                tabline = {
                    lualine_a = {
                        {
                            "buffers",
                            section_separators = { left = "", right = "" },
                            component_separators = { left = "", right = "" },
                            symbols = { modified = " ●", alternate_file = "" },
                        },
                    },
                },
            })
        end,
    },

    {
        "b0o/incline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        opts = {
            window = { placement = { horizontal = "right", vertical = "top" } },
            hide = { cursorline = "smart" },
            render = function(props)
                local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
                if name == "" then name = "[No Name]" end
                local icon, color = require("nvim-web-devicons").get_icon_color(name)
                return {
                    icon and { icon, " ", guifg = color } or "",
                    name,
                    vim.bo[props.buf].modified and " [+]" or "",
                }
            end,
        },
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({})
            require("which-key").add({
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>h", group = "Git hunk" },
                { "<leader>l", group = "Laravel" },
                { "<leader>p", group = "Phpactor" },
                { "<leader>r", group = "Refactor/Rename" },
                { "<leader>s", group = "Split/Harpoon" },
                { "<leader>c", group = "Code/Format" },
                { "gs", group = "Surround" },
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo" },
            { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Search todos" },
        },
        opts = {},
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader><leader>t", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
            { "<leader><leader>f", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },
        },
        opts = {},
    },

    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },

    {
        "nvim-mini/mini.surround",
        event = "VeryLazy",
        opts = {
            -- gs prefix: `s` belongs to flash.nvim
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",
            },
        },
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
        },
    },
}

