-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  -- signs = {
  --   add          = { text = '' }, -- +  
  --   change       = { text = '󰥛' }, -- ~ 󱑺 󰣁 󰓦 󰜥 󱑼 
  --   delete       = { text = '⎽' }, -- _ 𛲖 ＿ ₋ ⎽
  --   topdelete    = { text = '‾' }, -- ⁻ ⎺
  --   changedelete = { text = '󰥛' },
  --   untracked    = { text = '╳' }, -- ┆╳⛌
  -- },

  -- using color
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '˲' },
    topdelete    = { text = '˃' },
    changedelete = { text = '│' },
    untracked    = { text = '┆' },
  }
}
