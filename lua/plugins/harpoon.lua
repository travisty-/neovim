return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>1", desc = "Harpoon to File (1-9)" })
      for i = 2, 9 do
        table.insert(opts.spec, { "<leader>" .. i, hidden = true })
      end
      return opts
    end,
  },
}
