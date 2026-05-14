-- Overrides lazy.setup() when running Neovim on Nix. In other environments
-- this is a no-op. See modules/features/programs/neovim in my dotfiles for
-- the matching Nix configuration.

local M = {}

local function detected()
  return (vim.env.VIMRUNTIME or ""):match("/nix/store") ~= nil
end

function M.override(opts)
  if not detected() then
    return opts
  end

  -- Disable lazy.nvim's rtp/packpath reset (clobbers Nix-provided parsers);
  -- also disables the integration with luarocks for plugin management.
  opts.performance = opts.performance or {}
  opts.performance.rtp = opts.performance.rtp or {}
  opts.performance.rtp.reset = false
  opts.performance.reset_packpath = false
  opts.rocks = opts.rocks or {}
  opts.rocks.enabled = false

  -- Override lazy.nvim to source the nvim-treesitter package provided by Nix
  -- so the plugin, bundled queries, and parsers all share the same version.
  opts.dev = {
    path = vim.fn.stdpath("data") .. "/nix",
    patterns = { "^nvim%-treesitter$" },
    fallback = false,
  }

  -- Mason doesn't work on Nix because it downloads binaries that expect an FHS
  -- filesystem layout. Instead, Nix provides the entire toolchain including
  -- any nvim-treesitter parsers, which requires auto-install to be disabled.
  table.insert(opts.spec, {
    { "mason-org/mason.nvim", enabled = false },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = {}
        opts.auto_install = false
        return opts
      end,
    },
  })

  return opts
end

return M
