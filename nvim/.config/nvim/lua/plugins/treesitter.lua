return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter").install({
                "lua",
                "vim",
                "vimdoc",
                "bash",
                "json",
                "yaml",
                "markdown",
                "markdown_inline",
                "html",
                "css",
                "javascript",
                "typescript",
                "php",
                "phpdoc",
                "sql",
                "blade",
            })

            -- main branch no longer enables highlight/indent itself
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    if pcall(vim.treesitter.start, args.buf) then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move = { set_jumps = true },
            })

            local select = require("nvim-treesitter-textobjects.select")
            for key, obj in pairs({
                af = "@function.outer",
                ["if"] = "@function.inner",
                ac = "@class.outer",
                ic = "@class.inner",
                al = "@loop.outer",
                il = "@loop.inner",
            }) do
                vim.keymap.set({ "x", "o" }, key, function()
                    select.select_textobject(obj, "textobjects")
                end, { desc = obj })
            end

            local move = require("nvim-treesitter-textobjects.move")
            for fn, keys in pairs({
                goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
                goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
                goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
                goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
            }) do
                for key, obj in pairs(keys) do
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        move[fn](obj, "textobjects")
                    end, { desc = obj })
                end
            end
        end,
    },
}
