let
  mako = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2mysFaTdGB91xP+ByQr8GD97h1gK2AN6xURcokGCGj root@mako";
  suzumiya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXTroyrAS5VNrqAXJJZ4gs1osgzlYpPHWiASgOpJxGH root@suzumiya";
  systems = [ mako suzumiya ];

  siren = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNUMD65dLiKkAGSDHaAVNxu1NJW8U23hQzUqHCymuk9 <ssh://siren|ed25519>";
  users = [ siren ];

  allKeys = systems ++ users;
in
{
  "hercules-ci/secrets.age".publicKeys = allKeys;
  "hercules-ci/mako.age".publicKeys = allKeys;
  "hercules-ci/suzumiya.age".publicKeys = allKeys;
  "hercules-ci/binary-caches.age".publicKeys = allKeys;
  "openssh/edgerunner-public.age".publicKeys = allKeys;
  "openssh/edgerunner-private.age".publicKeys = allKeys;
}
