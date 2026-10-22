return {
    "ricardoramirezr/blade-nav.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "blade", "php" },

    config = function()
        require("blade-nav").setup({
            integrations = {
                cmp = false,
                coq = false,
            },
        })
    end,
}
