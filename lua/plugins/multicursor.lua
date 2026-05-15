return {
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local map = vim.keymap.set

      -- Add or skip a cursor by matching word/selection.
      map({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Add Cursor Next Match" })
      map({ "n", "x" }, "<C-p>", function() mc.matchAddCursor(-1) end, { desc = "Add Cursor Prev Match" })
      map({ "n", "x" }, "<leader>mn", function() mc.matchAddCursor(1) end, { desc = "Add Cursor Next Match" })
      map({ "n", "x" }, "<leader>mN", function() mc.matchAddCursor(-1) end, { desc = "Add Cursor Prev Match" })
      map({ "n", "x" }, "<leader>ms", function() mc.matchSkipCursor(1) end, { desc = "Skip Match Forward" })
      map({ "n", "x" }, "<leader>mS", function() mc.matchSkipCursor(-1) end, { desc = "Skip Match Backward" })
      map({ "n", "x" }, "<leader>mA", mc.matchAllAddCursors, { desc = "Add All Matches" })

      -- Add and remove cursors with control + left click.
      map("n", "<C-LeftMouse>", mc.handleMouse, { desc = "Multicursor Mouse Down" })
      map("n", "<C-LeftDrag>", mc.handleMouseDrag, { desc = "Multicursor Mouse Drag" })
      map("n", "<C-LeftRelease>", mc.handleMouseRelease, { desc = "Multicursor Mouse Release" })

      -- Disable and enable cursors.
      map({ "n", "x" }, "<C-q>", mc.toggleCursor, { desc = "Toggle Multicursor" })

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)

        -- Add or skip cursor above/below the main cursor.
        layerSet({ "n", "x" }, "<Up>", function() mc.lineAddCursor(-1) end, { desc = "Add Cursor Above" })
        layerSet({ "n", "x" }, "<Down>", function() mc.lineAddCursor(1) end, { desc = "Add Cursor Below" })
        layerSet({ "n", "x" }, "<leader><Up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip Line Above" })
        layerSet({ "n", "x" }, "<leader><Down>", function() mc.lineSkipCursor(1) end, { desc = "Skip Line Below" })

        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<Left>", mc.prevCursor, { desc = "Previous Cursor" })
        layerSet({ "n", "x" }, "<Right>", mc.nextCursor, { desc = "Next Cursor" })

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor, { desc = "Delete Cursor" })

        -- Enable and clear cursors using escape.
        layerSet("n", "<Esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end, { desc = "Enable / Clear Cursors" })
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>m", group = "multicursor", icon = "\u{f245}" },
      },
    },
  },
}
