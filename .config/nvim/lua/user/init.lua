return {
  plugins = {
    "nvim-neo-tree/neo-tree.nvim",
    config = function()
      require('neo-tree').setup {
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        }
      }
    end
  }
}
