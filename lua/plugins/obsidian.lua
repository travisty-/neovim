return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    cmd = "Obsidian",
    ft = "markdown",
    keys = {
      { "<leader>oo", "<cmd>Obsidian<cr>", desc = "Commands" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily note" },
      { "<leader>of", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
      { "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Tags" },
    },
    opts = {
      legacy_commands = false,
      picker = {
        name = "snacks.picker",
      },
      ui = { enable = false },
      workspaces = {
        {
          name = "personal",
          path = "~/.vaults/Personal",
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "obsidian", icon = { icon = "\u{f01c8}", color = "purple" } },
        { "<leader>ob", icon = { icon = "\u{f0339}", color = "blue" } },
        { "<leader>od", icon = { icon = "\u{f00f6}", color = "orange" } },
        { "<leader>on", icon = { icon = "\u{f039c}", color = "green" } },
        { "<leader>ot", icon = { icon = "\u{f04f9}", color = "yellow" } },
      },
    },
  },
}
