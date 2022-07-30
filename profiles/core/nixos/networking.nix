{ ... }:
{
  networking.networkmanager.enable = true;

  enchantment.erase-sys-darlings.persistent.system.directories = [ "/etc/NetworkManager/system-connections" ];
}
