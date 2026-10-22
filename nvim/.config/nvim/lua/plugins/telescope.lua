local ignore = { "vendor/", "node_modules/", "%.git/", "storage/framework/" }

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files({
                        hidden = true,
                        no_ignore = false,
                        file_ignore_patterns = ignore,
                    })
                end,
                desc = "Search files",
            },
            {
                "<leader>fa",
                function()
                    -- Includes vendor/ to read framework code
                    require("telescope.builtin").find_files({
                        hidden = true,
                        no_ignore = true,
                        file_ignore_patterns = { "%.git/" },
                    })
                end,
                desc = "Search all files",
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep({
                        file_ignore_patterns = ignore,
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    })
                end,
                desc = "Search text",
            },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Search buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Document symbols" },
            { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
            { "<leader>fr", "<cmd>Telescope lsp_references<CR>", desc = "References" },
        },
        config = function()
            require("telescope").setup({})
            require("telescope").load_extension("fzf")
        end,
    },
}

