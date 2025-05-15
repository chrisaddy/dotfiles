{pkgs, ...}: {
  home.packages = with pkgs; [
    mpd
    mpv
    rmpc
    yt-dlp
    ffmpeg
    (pkgs.writeShellScriptBin "newsboat-mpv" ''
      exec mpv --no-ytdl --ytdl=no "$(${pkgs.yt-dlp}/bin/yt-dlp --no-playlist -f "bestvideo[ext=mp4][protocol^=http]+bestaudio[ext=m4a][protocol^=http]/best[ext=mp4][protocol^=http]/best[protocol^=http]" -g "$1")"
    '')
  ];
  programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "newsboat-mpv";
    reloadTime = 5;
    reloadThreads = 10;
    extraConfig = ''
      bind-key j down
      bind-key k up
      bind-key h quit
      bind-key l open

      bind-key r reload

      bind-key o open-in-browser

      bind-key x toggle-article-read
      show-read-articles no
      show-read-feeds no

      display-article-progress yes

      save-path ~/vaults/zettelkasten/

      refresh-on-startup yes
      confirm-exit yes
    '';
    urls = [
      {url = "https://www.reddit.com/r/linuxmasterrace.rss";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCzzLIhDbFYU46T4VFBz_m_g";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7BRAd6W3wx1ySm7VjhIBbg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCs8mbJ-M142ZskR5VR0gBig";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC5GYwuvmAD_VyV6w5aFnnUw";}
      {url = "https://robinhood.engineering/feed";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKPLvnWhN1Qo51IDDZsmq1g";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCrr7y8rEXb7_RiVniwvzk9w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYNEoM8zIP0uAmGlrW1c7DA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJm2TgUqtK1_NLBrjNQ1P-w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJetJ7nDNLlEzDLXv7KIo0w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCB7TRghn_cOOq71aEAOvlzw";}
      {url = "https://lethain.com/feeds.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCIr4vkCsn0tdTW2xZ1jRG1g";}
      {url = "https://engineering.fb.com/category/production-engineering/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCcQWoBTNG__OwfZk9znWgCQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UClny6qj9Mv7uFo9XGUGYQBA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCo7hxFPDiZ6RRgGwf1W7emQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCGpJOTbsdZH_sBxihz6p_wg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCd3dNckv1Za2coSaHGHl5aA";}
      {url = "https://labs.spotify.com/feed/";}
      {url = "https://nullprogram.com/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCSp-OaMpsO8K0KkOqyBl7_w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYeiozh-4QwuC1sjgCmB92w";}
      {url = "https://engineering.fb.com/category/data-infrastructure/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCpScWes_g_Z95ViTF5vdkiA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCoxcjq-8xIDTYp3uz647V5A";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCr7lmzIk63PZnBw3bezl-Mg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCdpkTMgFiDkcAnNV7TmXntA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNvsIonJdJ5E4EXMa65VYpA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC-lOss13v6QhqkO9yfNVJEw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCa9-QWuBmHQYAUjO5IA6oXg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCPPZoYsfoSekIpLcz9plX1Q";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC9-y-6csu5WGm29I7JiwpnA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC-AYV0_pAqUGeXGzDGp0PjQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfz8x0lVzJpb_dgWm9kPVrw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2Zs9v2hL2qZZ7vsAENsg4w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJ3C_aunCEXCDUGB16XWY3g";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCKpA7cdEo6CL-Jcqhso2ZaQ";}
      {url = "https://slack.engineering/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_zBdZ0_H_jn41FDRG7q4Tw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCUMwY9iS8oMyWDYIe6_RmoA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCSXxklOmlUOJfjzOkKM07gg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCRwMQverxgWbv9Yu5aLpQ-w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_iD0xppBwwsrM9DegC5cQQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCkZFKKK-0YB0FvwoS8P7nHg";}
      {url = "https://www.joelonsoftware.com/rss.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCiT_r1GD7JSftnbViKHcOtQ";}
      {url = "https://blog.cleancoder.com/atom.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7UukP_hxrOsrwHrcHxOxxg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_V9wKk1Dd2rpZ4fxj7pKXA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCPbwhExawYrn9xxI21TFfyw";}
      {url = "https://github.blog/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCCBSoR9ZO0Uj7W6jH9Y317g";}
      {url = "https://www.etsy.com/codeascraft/rss";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCWQaM7SpSECp9FELz-cHzuQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCRoQoviWSNt55TxgnuYa17g";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC-0fWjosItIOD4ThhS6oyfA";}
      {url = "https://eng.lyft.com/feed";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCaiL2GDNpLYH6Wokkk1VNcg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC75suCpChvMVC_9ij7rUpxw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCK5R1BsMtGd4DtI5uGQRHIg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCj7ML5-da-bCCcHz0ipUmYQ";}
      {url = "https://medium.com/feed/netflix-techblog";}
      {url = "https://xkcd.com/rss.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCAbAsEZ-0LccTNbl8r-3EaQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCVls1GmFKf6WlTraIb_IaJg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCGKEMK3s-ZPbjVOIuAV8clQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCaen260-fj7Z7wBk0wp9jjg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCBX_-ls-dXuhFNSWSXcHrTA";}
      {url = "https://feeds.feedburner.com/oatmealfeed";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCV5fXrZLHCEsSWsRm0d6lJA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCqq5iqLTPwveEF2fpG2OzyA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCpzSy79UDdn0i-uVGOPyTLQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCDoiJEufoWOzn4G6iiKHI9w";}
      {url = "https://explosm.net/rss.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNJ1Ymd5yFuUPtn21xtRbbw";}
      {url = "https://rss.arxiv.org/rss/cs.AI";}
      {url = "https://rss.arxiv.org/rss/cs.LG";}
      {url = "https://rss.arxiv.org/rss/stat.ML";}
      {url = "https://flowingdata.com/feed";}
      {url = "https://medium.com/feed/airbnb-engineering";}
      {url = "https://www.microsoft.com/en-us/research/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCtLcjZ5KR0FmNX-aJDlfwxQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC-yewGHQbNFpDrGM0diZOLA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCp1hRBGoDHKSn4HiHIzkXAw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCK2nGbJkxJNDckF6uMeaY0A";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCQR_kmeb0lBEk1Zj_9LWDHA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7edjYPNhTm5LYJMT7UMt0Q";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfJxmjbygyA5KEdzzZv6Pbw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCchU2gYo5UunA6uh6JVOd9A";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCkDSI_e009BcateOQ4_FP0w";}
      {url = "https://cacm.acm.org/browse-by-subject/artificial-intelligence.rss";}
      {url = "https://gwern.substack.com/feed";}
      {url = "https://us-east1-ml-feeds.cloudfunctions.net/pwc/latest";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_CzsS7UTjcxJ-xXp1ftxtA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCjREVt2ZJU8ql-NC9Gu-TJw";}
      {url = "https://web.mit.edu/newsoffice/topic/mitcomputers-rss.xml";}
      {url = "https://www.countbayesie.com/blog?format=RSS";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCDvErgK0j5ur3aLgn6U-LqQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCts-XMcexTiPSR8QbyRGFxA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCwgKmJM4ZJQRJ-U5NjvR2dg";}
      {url = "https://medium.com/feed/airbnb-engineering";}
      {url = "https://ai.stanford.edu/feed/";}
      {url = "https://api.substack.com/feed/podcast/1084089.rss";}
      {url = "https://engineering.fb.com/category/ml-applications/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCMLtBahI5DMrt0NPvDSoIRQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCX7Y2qWriXpqocG97SFW2OQ";}
      {url = "https://googleaiblog.blogspot.com/atom.xml";}
      {url = "https://www.fast.ai/index.xml";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UChhMB_J0kz8eBJECy4d5uSQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJvwbnL8mN8HijridGNhfVQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCfZz8F37oSJ2rtcEJHM2kCg";}
      {url = "https://feeds.megaphone.fm/GLT4787413333";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCyNtlmLB73-7gtlBz00XOQQ";}
      {url = "https://rss.arxiv.org/rss/q-fin";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCqzFQr1LCC8xrr0fMcRctYg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCZoeVerYbdr0mGZJ1J-MBXw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCgBVkKoOAr3ajSdFFLp13_A";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA";}
      {url = "https://engineering.atspotify.com/feed/";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCbtEd1MuY6gd2RpdWqkzXFw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCYs3kVmLLfbaRL6Af2ELMHg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCBtbC-lVEvy31VTDLdDnidg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCA0XHv5MYr8mmQTJoJ4Z0IQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UClD25HlzCthOQJsv4v2QCnA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCp19_tJlXTN8kXoHJx7mIXQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCrk8Y2fsR5i_5c1iTR9tZpg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCoOae5nYA7VqaXzerajD0lg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC525q2RIufHjnaHOuIUFY9A";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_hukbByJP7OZ3Xm2tszacQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCMCXOXsxsPUcXijsEJUmDlA";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2D2CMWXMOVWx7giW1n3LIg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCIhJnsJ0IHlVNnYfp-gw_5Q";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCTEOM1hbEEMbEJ9wabA7q4w";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCQjBsscIa_mgEnSvWpm_9vw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCt1ES-_FMXQfM3JeO_FrOXw";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCbDmEdLs-SB3FjrDFQJ4TDg";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCb9fs9s67BXlX7rXVzRf5cQ";}
      {url = "https://www.youtube.com/feeds/videos.xml?channel_id=UCvyaZhkGWT2qvBRsta2jBgQ";}
    ];
  };
}
