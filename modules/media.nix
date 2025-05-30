{pkgs, ...}: {
  home.packages = with pkgs; [
    mpd
    mpv
    rmpc
    ffmpeg
  ];
}
