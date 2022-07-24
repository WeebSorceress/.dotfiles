{ lib, pkgs, ... }:
{
  services.earlyoom.enable = true;

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  time.timeZone = lib.mkDefault "America/Sao_Paulo";

  enchantment.erase-sys-darlings.persistent = {
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
