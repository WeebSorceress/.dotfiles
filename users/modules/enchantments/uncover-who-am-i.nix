{ config, options, lib, ... }:
{
  options.enchantment.uncover-who-am-i = {
    user = {
      nick = lib.mkOption { type = lib.types.str; example = "nickname"; default = config.home.username; };
      name = lib.mkOption { type = lib.types.str; example = "User Name"; default = ""; };
      email = lib.mkOption { type = lib.types.str; example = "user@email.com"; default = ""; };
      signingKey = lib.mkOption { type = lib.types.str; example = "FFF1234567890FFF"; default = ""; };
    };
  };
}
