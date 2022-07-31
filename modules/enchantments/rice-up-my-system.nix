{ config, lib, pkgs, ... }:
let
  cfg = config.enchantment.rice-up-my-system;
in
{
  options.enchantment.rice-up-my-system.enable = lib.mkEnableOption "Scrolls of System Rices";

  config = lib.mkIf cfg.enable {
    home-manager.users = lib.genAttrs config.enchantment.setup-my-defaults.users (user: { suites, ... }: { imports = suites.graphical; });

    services.dbus.packages = with pkgs; [ dconf ];
  };
}
