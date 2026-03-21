{ lib, headless ? false, ... }:

{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins/colorscheme.nix
    ./plugins/fzf.nix
    ./plugins/git.nix
    ./plugins/lsp.nix
    ./plugins/completion.nix
    ./plugins/conform.nix
    ./plugins/treesitter.nix
    ./plugins/trouble.nix
    ./plugins/navigation.nix
    ./plugins/which-key.nix
  ] ++ lib.optionals (!headless) [
    ./plugins/dashboard.nix
    ./plugins/notes.nix
    ./plugins/rust.nix
    ./plugins/lean.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
