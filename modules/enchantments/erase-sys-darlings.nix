{ config, lib, ... }:
let
  cfg = config.enchantment.erase-sys-darlings;
in
{
  options.enchantment.erase-sys-darlings = {
    enable = lib.mkEnableOption "Scrolls of System Impermanence";
    disk = {
      default = lib.mkOption { default = ""; };
      mirrored = lib.mkOption { default = ""; };
    };
    persistent = {
      path = lib.mkOption { default = "/persist"; };
      system = {
        files = lib.mkOption { default = [ ]; };
        directories = lib.mkOption { default = [ ]; };
      };
      user = {
        files = lib.mkOption { default = [ ]; };
        directories = lib.mkOption { default = [ ]; };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.mutableUsers = false;
    programs.fuse.userAllowOther = true;
    fileSystems."${cfg.persistent.path}".neededForBoot = true;
    system.activationScripts = lib.genAttrs config.enchantment.setup-my-defaults.users (user: {
      text = ''
        mkdir -p ${cfg.persistent.path}/home/${user}
        chown ${user}:users ${cfg.persistent.path}/home/${user}
      '';
    });
    age.identityPaths = [
      "${cfg.persistent.path}/etc/ssh/ssh_host_rsa_key"
      "${cfg.persistent.path}/etc/ssh/ssh_host_ed25519_key"
    ];
    environment.persistence."${cfg.persistent.path}" = with cfg.persistent.system; {
      inherit files directories;
      hideMounts = true;
    };
    home-manager.users = lib.genAttrs config.enchantment.setup-my-defaults.users (user: {
      enchantment.erase-usr-darlings = {
        enable = true;
        persistent = with cfg.persistent.user; {
          inherit files directories;
          path = cfg.persistent.path;
        };
      };
    });
  };
}
