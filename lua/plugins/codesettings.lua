-- https://github.com/mrjones2014/codesettings.nvim#quick-start
return {
  { "mrjones2014/codesettings.nvim", opts = {} }, -- Required for `setup()`
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mrjones2014/codesettings.nvim" },
    opts = function(_, opts)
      for _, server in ipairs({ "jsonls", "yamlls" }) do
        local spec = opts.servers[server]
        if spec then
          local schemastore_init = spec.before_init
          spec.before_init = function(client, config)
            require("codesettings").with_local_settings(config.name, config, { root_dir = config.root_dir })
            if schemastore_init then
              schemastore_init(client, config)
            end
          end
        end
      end
    end,
  },
}
