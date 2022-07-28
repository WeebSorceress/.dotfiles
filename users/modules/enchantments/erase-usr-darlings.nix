{ config, lib, ... }:
let
  cfg = config.enchantment.erase-usr-darlings;
in
{
  options.enchantment.erase-usr-darlings = {
    enable = lib.mkEnableOption "Scrolls of User Impermanence";
    persistent = {
      files = lib.mkOption { default = [ ]; };
      directories = lib.mkOption { default = [ ]; };
      path = lib.mkOption { default = "/persist"; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence."${cfg.persistent.path}/home/${config.home.username}" = with cfg.persistent; {
      inherit files directories;
      allowOther = true;
    };
  };
}
