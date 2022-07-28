{ pkgs, ... }:
{
  enchantment.uncover-who-am-i = {
    user = {
      nick = "WeebSorceress";
      name = "WeebSorceress";
      email = "hello@weebsorceress.anonaddy.me";
      signingKey = "7F57344317F0FA43";
    };
  };

  home.packages = with pkgs; [
    adl
    mpv
    yt-dlp
    hakuneko
    trackma-curses
    anime-downloader
  ];
}
