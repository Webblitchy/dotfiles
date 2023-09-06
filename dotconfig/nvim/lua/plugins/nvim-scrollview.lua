require('scrollview').setup({
  excluded_filetypes = { 'nerdtree' },
  scrollview_base = "left",
  current_only = true,
  winblend = 75, -- transparency
  base = 'buffer',
  signs_on_startup = {},
  scrollview_marks_characters = { "a" }, -- disable keymap conflict
})
