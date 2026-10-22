return {
    "Bleksak/laravel-ide-helper.nvim",
    ft = { "php" },

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        require("laravel-ide-helper").setup({
            save_before_write = true,
        })
    end,

    keys = {
        {
            "<leader>li",
            function()
                require("laravel-ide-helper").generate_models()
            end,
            desc = "Generate IDE Helper",
        },
    },
}
