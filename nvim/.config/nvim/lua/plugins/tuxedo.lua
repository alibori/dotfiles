return {
  "IogaMaster/tuxedo.nvim",
  cmd = { "Tuxedo" },
  keys = {
    { "<leader>tt", "<cmd>Tuxedo<cr>", desc = "Tuxedo (todo.txt)" },
  },
  opts = {
    create_todo_file = true,
    width_ratio = 0.95,
    height_ratio = 0.80,
  },
}
