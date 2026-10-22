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
            })
        end,
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
            { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Search todos" },
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
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            indent = { char = "│" },
            scope = { enabled = true },
        },
    },

    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },
}

