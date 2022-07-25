{ hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) nixos; };

  enchantment.erase-sys-darlings.users = [ "nixos" ];

  users.users.nixos = {
    isNormalUser = true;
    description = "NixOS";
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPXh4egJrGmJyFYY8r8GyjqM2OVo1lBZdoITd8S8TAc0 default-ssh@hercules-ci"
    ];
  };
}
