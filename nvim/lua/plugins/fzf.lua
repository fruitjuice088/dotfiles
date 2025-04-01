-- https://github.com/LockeAG/dotfiles-public/blob/7377fa8c39b4c8affeb83584e83b70270834a850/.nvim/lua/plugins/extras/fzf.lua#L107

return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
              ooooo o8o                        ooooo                                                     
              `888' `YP                        `888'                                                     
               888   '  ooo. .oo.  .oo.         888          .oooo.     oooooooo oooo    ooo             
               888      `888P"Y88bP"Y88b        888         `P  )88b   d'""7d8P   `88.  .8'              
               888       888   888   888        888          .oP"888     .d8P'     `88..8'               
               888       888   888   888        888       o d8(  888   .d8P'  .P    `888'    .o. .o. .o. 
              o888o     o888o o888o o888o      o888ooooood8 `Y888""8o d8888888P      .8'     Y8P Y8P Y8P 
                                                                                 .o..P'                  
                                                                                 `Y8P'                   
          ]],
        },
      },
    },
  },

  -- setup fzf-lua
  { import = "lazyvim.plugins.extras.editor.fzf" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
      },
    },
  },
}
