-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Strip trailing whitespace on save for dev filetypes
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.php", "*.blade.php", "*.lua", "*.js", "*.ts", "*.html", "*.css", "*.json", "*.yaml" },
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[%s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- Close certain windows with q
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "notify" },
    callback = function(event)
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
            buffer = event.buf,
            silent = true,
            desc = "Close window",
        })
    end,
})

-- Spell + wrap for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
})

-- phpactor dedicated action menu for PHP files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function(event)
        vim.keymap.set("n", "<leader>pa", function()
            local clients = vim.lsp.get_clients({ bufnr = 0, name = "phpactor" })
            if #clients == 0 then
                vim.notify("phpactor not attached", vim.log.levels.WARN)
                return
            end
            local client = clients[1]
            local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
            params.context = { diagnostics = {} }
            client:request("textDocument/codeAction", params, function(err, actions)
                if err or not actions or #actions == 0 then
                    vim.notify("No phpactor actions available", vim.log.levels.INFO)
                    return
                end
                vim.ui.select(actions, {
                    prompt = "Phpactor:",
                    format_item = function(a) return a.title end,
                }, function(action)
                    if not action then return end
                    if action.edit then
                        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                    end
                    if action.command then
                        local cmd = type(action.command) == "table" and action.command
                            or { command = action.command }
                        client:request("workspace/executeCommand", cmd, function() end)
                    end
                end)
            end, 0)
        end, { buffer = event.buf, desc = "Phpactor actions" })
    end,
})
