return {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            "<leader>F",
            function() require("spectre").open() end,
            desc = "Spectre: project search/replace",
        },
        {
            "<leader>Fw",
            function() require("spectre").open_visual({ select_word = true }) end,
            mode = { "n", "v" },
            desc = "Spectre: search word under cursor",
        },
    },
    config = function()
        require("spectre").setup()
    end,
}
