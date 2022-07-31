{ config, lib, hmUsers, ... }:
{
  enchantment.setup-my-defaults.users = [ "siren" ];

  home-manager.users = { inherit (hmUsers) siren; };

  users.users.siren = {
    isNormalUser = true;
    description = "NixOS";
    extraGroups = [ "wheel" ]
      ++ (lib.optional config.networking.networkmanager.enable "networkmanager");
    initialHashedPassword = "$6$iXlXkqZRrvcydGCw$B17KIREgeVBZ1StkgaDvHPakpvD4iJ1f6IntgVaJEYHkasYmg8PBDBAIDwV2tQpLRJGfC4Mjc2st/9N4fwXFU1";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>" ];
  };
}
