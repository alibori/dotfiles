local ignore = { "vendor", "node_modules", "storage/framework" }

-- Generated from ~/Downloads/AxLiRoLOGOPNG.png
local logo = {
    [[   ▄▄▄                ▄▄          ███     ▄▄▄▄▄▄▄]],
    [[  ▄████    ▄▄    ▄▄   ██        ▄▄▄▄▄     ██▀▀▀▀██     ▄▄]],
    [[  ██ ██    ▀██ ▄██▀   ██        ▀▀▀██     ██   ▄██  ▄██▀▀██▄]],
    [[ ███ ▄██     ███▀     ██           ██     ██████▀   ██    ██]],
    [[ ██▀▀▀██▄   ▄████▄    ██           ██     ██  ▀█▄   ██▄  ▄██]],
    [[██▀    ██  ██▀  ▀██   ████████  ████████  ██   ▀██   ▀████▀▀]],
}

local function header()
    local width = 0
    for _, line in ipairs(logo) do
        width = math.max(width, vim.fn.strchars(line))
    end

    local items = {}
    for i, line in ipairs(logo) do
        -- Same width on every line, or centering would shear the logo
        line = line .. string.rep(" ", width - vim.fn.strchars(line))
        table.insert(items, {
            align = "center",
            padding = i == #logo and 1 or 0,
            text = {
                { vim.fn.strcharpart(line, 0, 10), hl = "Normal" },
                -- The "x" (chars 10-20) is red like the logo
                { vim.fn.strcharpart(line, 10, 10), hl = "DiagnosticError" },
                { vim.fn.strcharpart(line, 20), hl = "Normal" },
            },
        })
    end
    return items
end

local function link(url, padding)
    return { align = "center", padding = padding, text = { { url, hl = "Comment" } } }
end

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<F12>", function() Snacks.terminal.toggle(nil, { win = { position = "float", border = "rounded" } }) end, mode = { "n", "t" }, desc = "Toggle terminal" },

        { "<leader>ff", function() Snacks.picker.files({ hidden = true, exclude = ignore }) end, desc = "Search files" },
        -- Includes vendor/ to read framework code
        { "<leader>fa", function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Search all files" },
        { "<leader>fg", function() Snacks.picker.grep({ hidden = true, exclude = ignore }) end, desc = "Search text" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Search buffers" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
        { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
        { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>fr", function() Snacks.picker.lsp_references() end, desc = "References" },
    },
    opts = {
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        notifier = { enabled = true },
        input = { enabled = true },
        indent = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        picker = { enabled = true, ui_select = true },
        dashboard = {
            enabled = true,
            width = 66, -- logo is wider than the default 60
            preset = {
                keys = {
                    { icon = "  ", key = "f", desc = "Find file", action = function() Snacks.picker.files() end },
                    { icon = "  ", key = "r", desc = "Recent files", action = function() Snacks.picker.recent() end },
                    { icon = "  ", key = "g", desc = "Grep", action = function() Snacks.picker.grep() end },
                    { icon = "  ", key = "e", desc = "Edit .env", action = ":e .env" },
                    { icon = "󰒲  ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = "  ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                header,
                link("https://axliro.dev/", 0),
                link("https://github.com/alibori", 0),
                link("https://www.youtube.com/@axlirodev", 2),
                { section = "keys", padding = 1 },
            },
        },
    },
}
