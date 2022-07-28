{ hmUsers, ... }:
{
  home-manager.users = { inherit (hmUsers) witch; };

  enchantment.erase-sys-darlings.users = [ "witch" ];

  users.users.witch = {
    isNormalUser = true;
    description = "NixOS";
    extraGroups = [ "wheel" ];
    initialHashedPassword = "$6$NS2OcGSCdT37.G.o$OlimZjp4ITvmEabxjovM5WcdL8noIrHWi9kYbLE5SPdTz4DxihAb51LnM8xTdS1VWbmdPrz3KJtkisyY5VFvY0";
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>" ];
  };
}
