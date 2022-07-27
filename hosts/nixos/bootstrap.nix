{ suites, profiles, ... }:
{
  imports = suites.main ++ [ profiles.bootloader.systemd-boot ];
}
