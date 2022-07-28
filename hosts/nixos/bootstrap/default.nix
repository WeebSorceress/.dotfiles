{ suites, pkgs, lib, ... }:
{
  imports = suites.iso;

  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "nixy-zfs-install" (lib.fileContents ./zfs-install.sh))
  ];
}
