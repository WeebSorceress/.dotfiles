{ suites, inputs, lib, ... }:
{
  imports = suites.station
    ++ (with inputs.nixos-hardware.nixosModules; [
    common-pc-laptop
    common-pc-laptop-ssd
    common-cpu-intel
  ]);

  services.hercules-ci-agent.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  enchantment.erase-sys-darlings.disk = {
    default = "/dev/disk/by-id/ata-P4-120_9D20106004931";
    mirrored = "/dev/disk/by-id/ata-P4-120_9D20106004951";
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  };
}
