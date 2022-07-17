{ suites, ... }:
# nixos-generate --format install-iso --flake '.#bootstrap'
{
  imports = suites.base ++ suites.user;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
}
