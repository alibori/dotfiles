return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "antosha417/nvim-lsp-file-operations",
        },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "File explorer" },
        },
        config = function()
            require("nvim-tree").setup({
                view = {
		    side = "right",
                    width = 60,
		    preserve_window_proportions = true,
                },
                filters = {
                    dotfiles = false,
                    git_ignored = false,
                },
                git = {
                    enable = true,
                },
                actions = {
                    open_file = {
                        quit_on_open = true,
                    },
                },
                renderer = {
		    full_name = true,
                    group_empty = true,
                },
            })

            require("lsp-file-operations").setup()
        end,
    },
}
