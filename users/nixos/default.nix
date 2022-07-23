{ hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) nixos; };

  enchantment.erase-sys-darlings.users = [ "nixos" ];

  users.users.nixos = {
    initialPassword = "nixos";
    description = "NixOS";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
