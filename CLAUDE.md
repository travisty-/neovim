# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal Neovim configuration built on the [LazyVim](https://www.lazyvim.org/) starter, with a Nix bridge that lets the same `~/.config/nvim` repo work on Nix-managed and non-Nix machines.

## Cross-platform design (load-bearing)

This config is shared verbatim between hosts running Nix-managed Neovim (where the toolchain comes from the OS) and hosts using vanilla Neovim (where Mason is expected to install tools). Detection is runtime, not build-time.

`lua/config/nix.lua` exports `M.override(opts)`, called by `lua/config/lazy.lua` as `require("lazy").setup(require("config.nix").override(opts))`. It detects Nix-wrapped Neovim via `vim.env.VIMRUNTIME:match("/nix/store")` and, only when detected, mutates the lazy.setup options to:

1. Disable lazy.nvim's `performance.rtp.reset` and `performance.reset_packpath` (otherwise lazy clobbers Nix-supplied packdir).
2. Disable `rocks` (luarocks integration, irrelevant on Nix).
3. Inject a `dev` block redirecting `nvim-treesitter` to a Nix-supplied copy at `xdg.dataFile."nvim/nix/nvim-treesitter"` (so plugin, queries, and parsers all share one nixpkgs revision).
4. Append a plugin-spec override that disables Mason (`mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`) and zeros out nvim-treesitter's `ensure_installed` / `auto_install` (Mason can't run on NixOS — downloads pre-built FHS-expecting binaries; treesitter parsers come from Nix).

On non-Nix machines `M.override` is a no-op — the config behaves like a stock LazyVim install with Mason functional.

The matching Nix-side configuration lives in the companion dotfiles repo at `modules/features/programs/neovim.nix`. LSPs / formatters / linters / treesitter grammars are supplied there via `programs.neovim.extraPackages` and `programs.neovim.plugins`. Do not add Mason-managed tools — add them to that Nix module instead.

## Layout

- `init.lua` — bootstrap (one line: `require("config.lazy")`).
- `lua/config/lazy.lua` — lazy.nvim bootstrap, LazyVim import, extras imports, lazy.setup options. Wrapped via `require("config.nix").override(opts)` — the only line that diverges from the LazyVim starter.
- `lua/config/{options,keymaps,autocmds}.lua` — LazyVim's per-concern overrides for built-in defaults.
- `lua/config/nix.lua` — the Nix bridge above.
- `lua/plugins/*.lua` — user plugin specs, auto-imported by `{ import = "plugins" }` in lazy.lua. Each file returns a lazy.nvim spec (table or list).

## Adding things

- **LazyVim extra:** add the import path to the `extras` array in `lazyvim.json`, or toggle via `:LazyExtras`. Browse available extras at `https://www.lazyvim.org/extras`.
- **New custom plugin:** create `lua/plugins/<name>.lua` returning the lazy.nvim spec.
- **Override a LazyVim default plugin:** add a spec in `lua/plugins/<name>.lua` referencing the same plugin name with `opts = ...`; lazy.nvim merges by plugin name.
- **A tool needed by a plugin on Nix (LSP/formatter/linter):** add it to `extraPackages` in the Nix module, not via Mason.

## Format & lint

`stylua` with the rules in `stylua.toml` (2-space indent, 120-col width). Run `stylua .` from the repo root.

## Plugin lock

`lazy-lock.json` is checked in; `:Lazy restore` reproduces the locked state. `:Lazy sync` updates and re-locks.

## Commit conventions

Title Case, action verb first, parenthetical context for plugin sources. Examples: `Add Rose Pine color scheme`, `Show hidden files (snacks.nvim)`, `Add support for managing Neovim via Nix`. One commit per logical change — keymaps, extras, plugins, and colorscheme tweaks are typically separate commits even when developed together.
