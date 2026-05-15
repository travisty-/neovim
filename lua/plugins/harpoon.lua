return {
  {
    "ThePrimeagen/harpoon",
    -- stylua: ignore
    keys = {
      { "<leader>h", function() Snacks.picker.pick("harpoon") end, desc = "Harpoon Quick Menu" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          harpoon = {
            title = "Harpoon",
            format = "file",
            finder = function()
              local items = {}
              local list = require("harpoon"):list()
              for i, item in ipairs(list.items) do
                local ctx = item.context or {}
                table.insert(items, {
                  idx = i,
                  text = item.value,
                  file = item.value,
                  pos = {
                    ctx.row or 0,
                    ctx.col or 0,
                  },
                })
              end
              return items
            end,
            actions = {
              harpoon_delete = function(picker)
                local list = require("harpoon"):list()
                local selected = picker:selected({ fallback = true })
                -- Descending order to avoid shifting indexes when removing items.
                table.sort(selected, function(a, b)
                  return a.idx > b.idx
                end)
                for _, item in ipairs(selected) do
                  list:remove_at(item.idx)
                end
                picker:refresh()
              end,
            },
            win = {
              input = { keys = { ["<C-x>"] = { "harpoon_delete", mode = { "n", "i" } } } },
              list = { keys = { ["dd"] = "harpoon_delete" } },
            },
            confirm = function(picker, item)
              picker:close()
              if item then
                local list = require("harpoon"):list()
                list:select(item.idx)
              end
            end,
          },
        },
      },
    },
  },
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
