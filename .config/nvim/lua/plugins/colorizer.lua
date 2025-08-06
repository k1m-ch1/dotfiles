-- ~/.config/nvim/lua/plugins/colorizer.lua
return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup()
  end,
  event = "BufReadPre", -- Optional: load plugin on file open
}
