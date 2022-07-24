{ suites, profiles, ... }:
{
  imports = suites.main ++ [ profiles.oracle ];
}
