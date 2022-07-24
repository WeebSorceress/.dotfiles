{ config, self, ... }:
let
  secrets = config.age.secrets;
  mkSecret = name: {
    file = "${self}/secrets/${name}";
    group = "hercules-ci-agent";
    owner = "hercules-ci-agent";
    mode = "0400";
  };
in
{
  age.secrets = {
    "hercules-ci/binary-caches.json" = mkSecret "hercules-ci/binary-caches.age";
    "hercules-ci/cluster-join-token.key" = mkSecret "hercules-ci/${config.networking.hostName}.age";
  };

  services.hercules-ci-agent = {
    settings = {
      concurrentTasks = "auto";
      binaryCachesPath = secrets."hercules-ci/binary-caches.json".path;
      clusterJoinTokenPath = secrets."hercules-ci/cluster-join-token.key".path;
    };
  };
}
