return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
  },
  config = function()
    require("telescope").setup({
      pickers = {
        find_files = {
          no_ignore = true,
          find_command = {
            "rg",
            "--files",
            "--hidden",
            "-g",
            "!**/.git/*",
            "-g",
            "!**/node_modules/*",
            "-g",
            "!**/dist/*",
            "-g",
            "!**/coverage/*",
          },
        },
      },
    })
  end,
}
