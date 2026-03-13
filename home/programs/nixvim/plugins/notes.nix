{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.telescope.enable = true;
    plugins.web-devicons.enable = true;

    extraPlugins = [
      (pkgs.vimPlugins.telekasten-nvim.overrideAttrs {
        dependencies = [];
        doCheck = false;
      })
    ];

    extraConfigLua = ''
      local notes_home = vim.fn.expand("~/wiki")
      require('telekasten').setup({ home = notes_home })
    '';

    keymaps = [
      { mode = "n"; key = "<leader>np"; action = "<cmd>Telekasten panel<CR>"; options.desc = "Notes Panel"; }
      { mode = "n"; key = "<leader>nl"; action = "<cmd>Telekasten follow_link<CR>"; options.desc = "Notes follow link"; }
      { mode = "n"; key = "<leader>ntt"; action.__raw = "function() require('telekasten').toggle_todo() end"; options.desc = "Toggle TODO"; }
    ];
  };
}
