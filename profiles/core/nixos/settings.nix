{ lib, pkgs, ... }:
{
  services.earlyoom.enable = true;

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  enchantment.erase-sys-darlings.persistent.system = {
    directories = [ "/var/log" ];
    files = [ "/etc/machine-id" ];
  };

  systemd = {
    services.clear-log = {
      description = "Clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=21d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };
}
