# telescope-picker-history-action

A useful telescope.nvim action to switch between pickers in the history

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim), with my default key mappings:

```lua
-- telescope settings
{
  'nvim-telescope/telescope.nvim',
  opts = {
    -- ... your telescope config
    defaults = {
      -- ... your other defaults
      cache_picker = {
        -- we need to have a picker history we can work with
        num_pickers = 100
      }
      mapppings = {
        i = {
          ["<C-,>"] = function()
            require'telescope-picker-history-action'.prev_picker()
          end,
          ["<C-.>"] = function()
            require'telescope-picker-history-action'.next_picker()
          end,
        }
      }
    }
  }
},

-- plugin installation
{
  'prochri/telescope-picker-history-action',
  opts = true
}
```
