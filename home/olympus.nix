{pkgs, nixvim, ...}: {
  imports = [
    ./common.nix
    ../modules/ai.nix
    ../modules/gcloud.nix
    ../modules/ghostty.nix
    ../modules/git.nix
    ../modules/helix.nix
    ../modules/media.nix
    ../modules/nushell.nix
    ../modules/ocaml.nix
    ../modules/tmux.nix
    ../modules/vim.nix
    nixvim.homeManagerModules.nixvim
  ];
  home.username = "chrisaddy";
  home.homeDirectory = "/Users/chrisaddy";
}
