-- https://github.com/mrjones2014/codesettings.nvim#quick-start
return {
  "mrjones2014/codesettings.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mrjones2014/codesettings.nvim" },
    opts = {
      -- Merges local project settings (e.g. .vscode/settings.json) into LSP servers.
      -- The `before_init` hook resolves per server, so we register two separate hooks
      -- to handle servers that already have one (by wrapping it) and those that don't.
      servers = {
        ["*"] = {
          before_init = function(_, config)
            require("codesettings").with_local_settings(config.name, config, { root_dir = config.root_dir })
          end,
        },
      },
      setup = {
        ["*"] = function(_, opts)
          local before_init = opts.before_init
          opts.before_init = function(client, config)
            require("codesettings").with_local_settings(config.name, config, { root_dir = config.root_dir })
            if before_init then
              before_init(client, config)
            end
          end
        end,
      },
    },
  },
}
