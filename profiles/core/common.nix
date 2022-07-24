{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  imports = [ ../cachix ];

  environment = {
    systemPackages = with pkgs; [
      # alejandra # TODO: must come from unstable channel
      binutils
      coreutils
      curl
      direnv
      dnsutils
      fd
      git
      jq
      moreutils
      nix-index
      nmap
      tealdeer
      whois
    ];


    shellAliases =
      let
        ifSudo = lib.mkIf (isDarwin || config.security.sudo.enable);
      in
      {
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";
      };
  };

  system.stateVersion = "22.05";
}
