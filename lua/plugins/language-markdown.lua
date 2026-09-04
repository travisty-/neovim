return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rumdl = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "rumdl", "markdown-toc" },
      },
    },
  },
}
