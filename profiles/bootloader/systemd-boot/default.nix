{ lib, ... }:
{
  fileSystems."/" = lib.mkDefault { device = "/dev/disk/by-label/nixos"; };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
