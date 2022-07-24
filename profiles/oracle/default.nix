{ suites, modulesPath, lib, ... }:
{
  imports = suites.main ++ [ (modulesPath + "/profiles/qemu-guest.nix") ];

  zramSwap.memoryPercent = lib.mkForce 100;

  fileSystems = {
    "/boot" = { device = "/dev/disk/by-label/UEFI"; fsType = "vfat"; };
    "/" = { device = "/dev/disk/by-label/cloudimg-rootfs"; fsType = "ext4"; };
  };

  boot = {
    initrd = {
      kernelModules = [ "nvme" ];
      availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
    };
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
  };
}
