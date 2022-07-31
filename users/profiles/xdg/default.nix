{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [ xdg-user-dirs xdg_utils ];

  enchantment.erase-usr-darlings.persistent.directories = [
    "Desktop"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Public"
    "Templates"
    "Videos"
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
      videos = "$HOME/Videos";
    };
  };
}
