{ hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) siren; };

  enchantment.erase-sys-darlings.users = [ "siren" ];

  users.users.siren = {
    isNormalUser = true;
    description = "NixOS";
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$iXlXkqZRrvcydGCw$B17KIREgeVBZ1StkgaDvHPakpvD4iJ1f6IntgVaJEYHkasYmg8PBDBAIDwV2tQpLRJGfC4Mjc2st/9N4fwXFU1";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>" ];
  };
}
