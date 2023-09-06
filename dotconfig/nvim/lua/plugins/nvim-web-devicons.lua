-- [[ Configure nvim-web-devicons ]]
require 'nvim-web-devicons'.setup {

  color_icons = true,

  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true,

  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = false,

  -- filename : ["filename"] = {}
  -- type : type = {}
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    },
    tex = {
      icon = ""
    },
    yml = {
      icon = "",
      color = "#cb171e",
    }
  },
}
