{ ... }:
{
  imports = [ ../common.nix ] ++ [
    ./nix.nix
    ./ssh.nix
    ./font.nix
    ./zram.nix
    ./shell.nix
    ./security.nix
    ./settings.nix
    ./networking.nix
  ];
}
