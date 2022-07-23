{ config, lib, ... }:
let
  cfg = config.enchantment.erase-sys-darlings;
in
{
  options.enchantment.erase-sys-darlings = {
    enable = lib.mkEnableOption "Scrolls of System Impermanence";
    users = lib.mkOption { default = [ ]; };
    persistent = {
      files = lib.mkOption { default = [ ]; };
      directories = lib.mkOption { default = [ ]; };
    };
  };

  config = lib.mkIf cfg.enable {
    users.mutableUsers = false;
    fileSystems."/persist".neededForBoot = true;
    home-manager.users = lib.genAttrs cfg.users (user: { enchantment.erase-usr-darlings.enable = true; });
    environment.persistence."/persist" = with cfg.persistent; {
      inherit files directories;
      hideMounts = true;
    };
  };
}
