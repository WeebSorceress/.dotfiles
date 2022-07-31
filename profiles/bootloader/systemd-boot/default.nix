{ lib, ... }:
{
  fileSystems."/" = lib.mkDefault { device = "/dev/disk/by-label/nixos"; };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
  };
}
