return {
    "adalessa/laravel.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "tpope/vim-dotenv",
        "MunifTanjim/nui.nvim",
        "kevinhwang91/promise-async",
	"nvim-neotest/nvim-nio",
    },

    ft = { "php", "blade" },

    keys = {
        { "<leader>la", function() Laravel.pickers.artisan() end, desc = "Laravel Artisan" },
        { "<leader>lr", function() Laravel.pickers.routes() end, desc = "Laravel Routes" },
        { "<leader>lm", function() Laravel.pickers.make() end, desc = "Laravel Make" },
        { "<leader>lt", function() Laravel.extensions.tinker() end, desc = "Laravel Tinker" },
        { "<leader>le", function() Laravel.commands.run("env:configure") end, desc = "Laravel Env" },
        { "<leader>ld", function()
            vim.ui.input({ prompt = "Docker container name: " }, function(container)
                if not container or container == "" then return end
                local value = {
                    name = "docker-" .. container,
                    map = {
                        php      = { "docker", "exec", container, "php" },
                        composer = { "docker", "exec", container, "composer" },
                        npm      = { "docker", "exec", container, "npm" },
                        yarn     = { "docker", "exec", container, "yarn" },
                    },
                    path = vim.uv.cwd(),
                }
                Laravel("laravel.core.options_manager").set(value)
                Laravel("laravel.core.env"):boot()
                vim.notify("[Laravel] Docker env: container='" .. container .. "'", vim.log.levels.INFO)
            end)
        end, desc = "Laravel Docker env" },
    },

    config = function()
        require("laravel").setup({
            lsp_server = "intelephense",
            features = {
                pickers = {
                    enable = true,
                    provider = "telescope",
                },
            },
        })

        -- options_manager.set() drops manager.save() return value → false "Error saving config".
        -- Still unfixed upstream as of laravel.nvim 587db9f (2026-08-30); drop when it returns save().
        local mgr = require("laravel.core.options_manager")
        local original_set = mgr.set
        mgr.set = function(key, value)
            original_set(key, value)
            return mgr.save()
        end
    end,
}
