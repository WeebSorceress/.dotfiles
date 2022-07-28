{ ... }:
{
  users.users.nixos = {
    isNormalUser = true;
    description = "NixOS";
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>" ];
  };
}
