{pkgs, ...}: {
  home.packages = with pkgs; [
    freetube
    mpd
    mpv
    rmpc
    yt-dlp
    ffmpeg
    (pkgs.writeShellScriptBin "newsboat-mpv" ''
      exec mpv --no-ytdl --ytdl=no "$(${pkgs.yt-dlp}/bin/yt-dlp --no-playlist -f "bestvideo[ext=mp4][protocol^=http]+bestaudio[ext=m4a][protocol^=http]/best[ext=mp4][protocol^=http]/best[protocol^=http]" -g "$1")"
    '')
  ];
}
