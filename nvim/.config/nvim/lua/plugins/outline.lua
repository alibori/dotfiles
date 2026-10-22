-- outline.nvim — symbol/structure sidebar (PhpStorm "Structure" panel).
-- Lists classes, methods, properties of the current file for fast navigation.
return {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
        { "<leader>cs", "<cmd>Outline<CR>", desc = "Structure (symbols outline)" },
    },
    opts = {
        outline_window = {
            position = "right",
            width = 30,
        },
        symbols = {
            icon_source = "lspkind",
        },
    },
}
