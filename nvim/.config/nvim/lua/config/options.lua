local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.clipboard:append("unnamedplus")

opt.number = true
opt.relativenumber = false

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false

opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"

opt.ignorecase = true
opt.smartcase = true

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 250
opt.timeoutlen = 400

opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.completeopt = { "menu", "menuone", "noselect" }
