{pkgs, ...}: {
  programs.helix = {
    enable = true;
    # defaultEditor = true;
    # languages = {
    #   language = [
    #     {
    #       name = "rust";
    #       auto-format = false;
    #     }
    #   ];
    # };
    # ignores = [".stack-work"];
    # extraPackages = with pkgs; [];
    # extraConfig = ''
    # '';
  };
}
