return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        keys = {
            {
                "<leader>cf",
                function() require("conform").format({ async = true }) end,
                mode = { "n", "x" },
                desc = "Format file/selection",
            },
            {
                "<leader>cF",
                function()
                    vim.g.autoformat = vim.g.autoformat == false
                    vim.notify("Format on save: " .. (vim.g.autoformat and "on" or "off"))
                end,
                desc = "Toggle format on save",
            },
        },
        opts = {
            formatters_by_ft = {
                -- pint resolves vendor/bin/pint first, so each project's pint.json applies
                php = { "pint" },
                blade = { "blade-formatter" },
                lua = { "stylua" },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                css = { "prettierd" },
                json = { "prettierd" },
                yaml = { "prettierd" },
            },
            notify_no_formatters = false,
            format_on_save = function()
                if vim.g.autoformat == false then
                    return
                end
                return { timeout_ms = 3000, lsp_format = "fallback" }
            end,
        },
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = { php = { "phpstan" } }

            local function run()
                -- Only in projects that ship PHPStan/Larastan
                if vim.fn.executable("vendor/bin/phpstan") == 1 then
                    lint.try_lint()
                end
            end

            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
                group = vim.api.nvim_create_augroup("lint", { clear = true }),
                callback = run,
            })
            run() -- buffer that triggered lazy-loading already fired BufReadPost
        end,
    },
}
