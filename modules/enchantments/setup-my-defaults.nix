{ config, lib, pkgs, ... }:
let
  cfg = config.enchantment.setup-my-defaults;
in
{
  options.enchantment.setup-my-defaults.users = lib.mkOption { default = [ ]; };
}
