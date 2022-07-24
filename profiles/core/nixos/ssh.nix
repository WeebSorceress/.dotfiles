{ lib, ... }:
{
  programs.ssh.startAgent = true;

  enchantment.erase-sys-darlings.persistent.files = [
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
  ];

  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    passwordAuthentication = false;
    openFirewall = lib.mkDefault true;
    kbdInteractiveAuthentication = false;
    permitRootLogin = lib.mkDefault "prohibit-password";
  };
}
