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
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence."/persist/home/${config.home.username}" = with cfg.persistent; {
      inherit files directories;
      allowOther = true;
    };
  };
}
