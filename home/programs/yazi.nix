{ ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        ratio = [ 0 4 3 ];
      };
    };
  };
}
