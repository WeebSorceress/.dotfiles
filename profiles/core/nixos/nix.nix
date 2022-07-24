{ pkgs, ... }:
{
  enchantment.erase-sys-darlings.persistent.files = [ "/root/.local/share/nix/trusted-settings.json" ];

  nix = {
    useSandbox = true;
    gc.automatic = true;
    autoOptimiseStore = true;
    optimise.automatic = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "root" "@wheel" ];
    systemFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  environment.shellAliases = {
    n = "nix";
    np = "n profile";
    ni = "np install";
    nr = "np remove";
    ns = "n search --no-update-lock-file";
    nf = "n flake";
    nepl = "n repl '<nixpkgs>'";
    srch = "ns nixos";
    orch = "ns override";

    mn = with pkgs; ''
      ${manix}/bin/manix "" | ${ripgrep}/bin/rg '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | ${skim}/bin/sk --preview="manix '{}'" | xargs manix
    '';
  };
}
