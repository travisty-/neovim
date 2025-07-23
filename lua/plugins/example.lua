-- Since this is just an example spec, don't actually load anything here and return an empty spec.
-- stylua: ignore
if true then return {} end

-- Every spec file under the "plugins" directory will be loaded automatically by lazy.nvim.
-- In your plugin files, you can:
-- * Add extra plugins
-- * Enable/disable LazyVim plugins
-- * Override the configuration of LazyVim plugins
return {
  -- Add gruvbox.
  { "ellisonleao/gruvbox.nvim" },

  -- Configure LazyVim to load gruvbox.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- Change trouble config.
  {
    "folke/trouble.nvim",
    -- Opts will be merged with the parent spec.
    opts = { use_diagnostic_signs = true },
  },

  -- Disable trouble.
  { "folke/trouble.nvim", enabled = false },

  -- Override nvim-cmp and add cmp-emoji.
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- Change some telescope options.
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Add a keymap to browse plugin files.
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- Change some options.
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- Add pyright to lspconfig.
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig.
        pyright = {},
      },
    },
  },

  -- Add tsserver and setup with typescript.nvim instead of lspconfig.
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig.
        tsserver = {},
      },
      -- You can do any additional lspserver setup here.
      -- return true if you don't want this server to be setup with lspconfig.
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- Example setup for typescript.nvim.
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server.
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- For typescript, LazyVim also includes extra specs to properly setup lspconfig,
  -- treesitter, mason and typescript.nvim. So instead of the above, you can use:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- Add more treesitter parsers:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- Since `vim.tbl_deep_extend` can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value. If you'd rather extend
  -- the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add tsx and treesitter.
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- The opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- Or you can return new options to override all the defaults:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[Add your custom lualine config here]]
      }
    end,
  },

  -- Use mini.starter instead of alpha.
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- Add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc.
  { import = "lazyvim.plugins.extras.lang.json" },

  -- Add any tools you want to have installed below:
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
