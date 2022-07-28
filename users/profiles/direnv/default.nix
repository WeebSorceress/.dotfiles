{
  enchantment.erase-usr-darlings.persistent.directories = [ ".local/share/direnv" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
