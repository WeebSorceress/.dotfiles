{ lib, ... }:
{
  enchantment.setup-my-defaults.users = [ "root" ];

  users.users.root = {
    initialHashedPassword = lib.mkForce null;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>" ];
  };
}
