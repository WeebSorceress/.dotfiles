{ suites, profiles, ... }:
# nixos-generate --format install-iso --flake '.#bootstrap'
# OR
# nix run github:nix-community/nixos-generators -- --format install-iso --flake '.#bootstrap'
{
  imports = suites.main ++ [ profiles.bootloader.systemd-boot ];

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}
