{ config, lib, ... }:
{
  enchantment.erase-sys-darlings.persistent.directories = lib.mkIf config.networking.networkmanager.enable [
    "/etc/NetworkManager/system-connections"
  ];

  networking.networkmanager.enable = !config.networking.wireless.enable;
}
