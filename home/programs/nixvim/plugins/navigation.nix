{ ... }:

{
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        delete_to_trash = true;
      };
    };

    plugins.aerial = {
      enable = true;
      settings = {
        attach_mode = "global";
        backends = [ "treesitter" "lsp" "markdown" "man" ];
        ignore = { filetypes = [ "gomod" ]; };
        close_behavior = "auto";
        default_bindings = true;
        default_direction = "auto";
        highlight_mode = "split";
        highlight_closest = true;
        max_width = 0.1;
        name = "aerial";
        open_automatic = false;
        position = "left";
        show_guides = true;
        sort = true;
        symbol_filter = false;
        toggle_auto_fold = true;
        tree_width = 30;
        use_default_mappings = true;
        use_icons = true;
        width = 30;
      };
    };

    plugins.undotree.enable = true;

    keymaps = [
      { mode = "n"; key = "<leader>o"; action = "<cmd>Oil<CR>"; options.desc = "Open parent directory with Oil"; }
      { mode = "n"; key = "<leader>et"; action = "<cmd>AerialToggle<cr>"; options.desc = "Toggle aerial"; }
      { mode = "n"; key = "<leader>u"; action = "<cmd>lua require('undotree').toggle()<cr>"; options.desc = "Toggle undotree"; }
    ];
  };
}
