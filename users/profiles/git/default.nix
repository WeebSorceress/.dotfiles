{ config, lib, ... }:
let
  cfg = config.enchantment.uncover-who-am-i;
in
{
  programs.git = {
    enable = true;

    extraConfig = with cfg.user; {
      pull.rebase = false;
      user = { inherit name signingKey email; };
      commit.gpgSign = lib.mkIf (signingKey != "") true;
    };

    aliases = {
      c = "commit";
      d = "diff";
      s = "s";

      soft = "reset --soft";
      hard = "reset --hard";
      s1ft = "soft HEAD~1";
      h1rd = "hard HEAD~1";

      plog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      tlog = "log --stat --since='1 Day Ago' --graph --pretty=oneline --abbrev-commit --date=relative";

      rank = "shortlog -sn --no-merges";
    };
  };
}
