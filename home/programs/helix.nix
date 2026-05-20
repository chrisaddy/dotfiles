{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_macchiato";
      line-number = "relative";
      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "┊";
          skip-levels = 1;
        };
      };
      lsp = {
        enable = true;
        auto-signature-help = true;
        display-message = true;
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
      {
        name = "rust";
        auto-format = true;
        roots = [
          "Cargo.lock"
          "Cargo.toml"
        ];
        formatter = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
      }
    ];
  };
}
