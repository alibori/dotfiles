local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Close window" })

-- Clear search highlight (moved off <leader>h to free the gitsigns hunk group)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })

map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Mouse
vim.opt.mouse = "a"

-- LSP (gd / K live in LspAttach — buffer-local, see lsp.lua)
map("n", "<leader>k", function()
  vim.lsp.buf.signature_help({ border = "rounded" })
end, { desc = "Show signature help" })

map("i", "<C-s>", function()
  vim.lsp.buf.signature_help({ border = "rounded" })
end, { desc = "Show signature help" })

map("n", "<C-LeftMouse>", function()
  vim.lsp.buf.definition()
end, { desc = "Ctrl+click: go to definition" })

map("i", "<C-LeftMouse>", function()
  vim.cmd("stopinsert")
  vim.schedule(function()
    vim.lsp.buf.definition()
  end)
end, { desc = "Ctrl+click: go to definition" })

-- Better paste in visual mode (don't overwrite clipboard)
map("v", "p", '"_dP', { desc = "Paste without overwriting clipboard" })

-- Centered search navigation
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Quickfix navigation
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })

-- Quick open .env
map("n", "<leader>ee", "<cmd>e .env<CR>", { desc = "Edit .env" })

