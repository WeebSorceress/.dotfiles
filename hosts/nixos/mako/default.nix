{ suites, profiles, ... }:
{
  imports = suites.main ++ [ profiles.oracle ];

  services.hercules-ci-agent.enable = true;
}
