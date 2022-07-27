{ config, lib, self, ... }:
let
  secrets = config.age.secrets;
  mkSecret = name: {
    file = "${self}/secrets/${name}";
    group = "hercules-ci-agent";
    owner = "hercules-ci-agent";
    mode = "0400";
  };
in
lib.mkIf config.services.hercules-ci-agent.enable
{
  age.secrets = {
    "hercules-ci/secrets.json" = mkSecret "hercules-ci/secrets.age";
    "hercules-ci/binary-caches.json" = mkSecret "hercules-ci/binary-caches.age";
    "hercules-ci/cluster-join-token.key" = mkSecret "hercules-ci/${config.networking.hostName}.age";
  };

  services.hercules-ci-agent = {
    settings = {
      concurrentTasks = "auto";
      secretsJsonPath = secrets."hercules-ci/secrets.json".path;
      binaryCachesPath = secrets."hercules-ci/binary-caches.json".path;
      clusterJoinTokenPath = secrets."hercules-ci/cluster-join-token.key".path;
    };
  };
}
