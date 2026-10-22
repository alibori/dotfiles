-- refactoring.nvim — extract method/variable/block with visual UX.
-- Complements phpactor's PHP-aware refactors (<leader>pa) with editor-level
-- extractions. Keymaps live under the <leader>r "Refactor" group.
return {
    "ThePrimeagen/refactoring.nvim",
    -- Pinned to the last pre-rewrite commit. The Oct 2025 rewrite requires
    -- Neovim 0.12 + the lewis6991/async.nvim dependency and a new API.
    -- Unpin when upgrading to Neovim 0.12 (see migration note in keymaps below).
    commit = "4a33e00e458bcee7310adf6cc9a2a71e2c0ffb55",
    pin = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        {
            "<leader>re",
            function() require("refactoring").refactor("Extract Function") end,
            mode = "x",
            desc = "Extract function",
        },
        {
            "<leader>rv",
            function() require("refactoring").refactor("Extract Variable") end,
            mode = "x",
            desc = "Extract variable",
        },
        {
            "<leader>ri",
            function() require("refactoring").refactor("Inline Variable") end,
            mode = { "n", "x" },
            desc = "Inline variable",
        },
        {
            "<leader>rb",
            function() require("refactoring").refactor("Extract Block") end,
            mode = "n",
            desc = "Extract block",
        },
        {
            "<leader>rr",
            function() require("refactoring").select_refactor() end,
            mode = { "n", "x" },
            desc = "Select refactor",
        },
    },
    opts = {},
}
