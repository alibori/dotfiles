return {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
        {
            "<leader>n",
            function() require("neogen").generate() end,
            desc = "Generate docblock",
        },
    },
    opts = {
        snippet_engine = "nvim",
        languages = {
            php = {
                template = {
                    annotation_convention = "phpdoc",
                },
            },
        },
    },
}
