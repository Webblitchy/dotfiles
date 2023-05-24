-- [[ Configure VimTex ]] (for Latex)
vim.g.tex_flavor = 'latex'
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"

vim.g.vimtex_quickfix_enabled = 1
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_quickfix_mode = 1  -- auto open and go into
vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1

vim.g.vimtex_compiler_latexmk = {
  build_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = {
    '-pdf',
    '-shell-escape', -- necessary for minted (but can be dangerous)
    '-verbose',
    '-halt-on-error',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
    '-bibtex',
  },
}
-- Clean latex output files when exiting
vim.cmd [[autocmd! User VimtexEventQuit call vimtex#compiler#clean(0)]]
