return {
    {
        "akinsho/toggleterm.nvim",

        version = "*",

        config = function()
            require("toggleterm").setup({
                direction = "float",

                shade_terminals = true,
                start_in_insert = true,
                insert_mappings = true,

                float_opts = {
                    border = "rounded",
                },
            })

            vim.keymap.set(
                { "n", "t" },
                "<F12>",
                "<cmd>ToggleTerm<CR>",
                { desc = "Toggle terminal" }
            )
        end,
    },
}
