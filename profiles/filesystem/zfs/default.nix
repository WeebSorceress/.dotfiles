{ config, lib, ... }:
let
  mkFs = device: fsType: options: { inherit device fsType options; };
  disks = config.enchantment.erase-sys-darlings.disk;
in
{
  enchantment.erase-sys-darlings.enable = true;

  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

  swapDevices = [
    { device = "${disks.default}-part2"; randomEncryption = true; }
    { device = "${disks.mirrored}-part2"; randomEncryption = true; }
  ];

  fileSystems = {
    "/" = mkFs "rpool/nixos/root" "zfs" [ "zfsutil" ];
    "/nix" = mkFs "rpool/nixos/nix" "zfs" [ "zfsutil" ];
    "/persist" = mkFs "rpool/nixos/persist" "zfs" [ "zfsutil" ];
    "/boot" = mkFs "${disks.default}-part3" "vfat" [ "X-mount.mkdir" ];
    "/boot-mirror" = mkFs "${disks.mirrored}-part3" "vfat" [ "X-mount.mkdir" ];
  };

  boot = {
    zfs.devNodes = "/dev";
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "nohibernate" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    initrd.postDeviceCommands = lib.mkAfter "zfs rollback -r rpool/nixos/root@blank";
  };

  services.zfs = {
    trim = {
      enable = true;
      interval = "weekly";
    };
    autoScrub = {
      enable = true;
      interval = "daily";
      pools = [ "rpool" ];
    };
    autoSnapshot = {
      daily = 7;
      weekly = 4;
      hourly = 24;
      monthly = 12;
      frequent = 4;
      enable = true;
      flags = "-k -p --utc";
    };
  };
}
