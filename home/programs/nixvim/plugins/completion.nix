{ ... }:

{
  programs.nixvim = {
    plugins.nvim-autopairs.enable = true;
    # mini.completion is configured in dashboard.nix via the mini module
  };
}
