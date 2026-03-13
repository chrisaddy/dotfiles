{ ... }:

{
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      settings = {
        winopts = {
          col = 0.3;
          height = 0.9;
          row = 0.99;
          width = 0.93;
        };
        buffers = {
          prompt = "Buffers❯ ";
          color_icons = true;
          sort_lastused = true;
        };
        files = {
          color_icons = true;
          file_icons = true;
          git_icons = true;
          find_opts = "-type f -not -path '*.git/objects*' -not -path '*.env*'";
          multiprocess = true;
          prompt = "Files❯ ";
        };
      };
      keymaps = {
        "<leader>f<leader>" = { action = "builtin"; options.desc = "fzf menu"; };
        "<leader><leader>" = { action = "buffers"; options.desc = "buffers"; };
        "<leader>fc" = { action = "command_history"; options.desc = "command history"; };
        "<leader>ff" = { action = "files"; options.desc = "files"; };
        "<leader>fg" = { action = "live_grep"; options.desc = "grep"; };
        "<leader>fk" = { action = "keymaps"; options.desc = "keymaps"; };
        "<leader>fm" = { action = "marks"; options.desc = "marks"; };
        "<leader>fr" = { action = "registers"; options.desc = "registers"; };
      };
    };
  };
}
