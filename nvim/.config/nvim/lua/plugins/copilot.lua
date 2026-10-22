return {
  "github/copilot.vim",

  event = "InsertEnter",

  -- Globals must be set before the plugin is sourced, so use init (not config)
  init = function()
    -- Disable TAB by default (blink.cmp owns <Tab>)
    vim.g.copilot_no_tab_map = true

    -- Enable for filetypes copilot.vim disables by default
    vim.g.copilot_filetypes = {
      markdown = true,
      gitcommit = true,
      yaml = true,
    }
  end,

  config = function()
    -- Accept suggestion with Ctrl+J
    vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      silent = true,
    })
  end,
}
