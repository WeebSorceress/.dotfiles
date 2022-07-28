# [Bootstrap ISO][Bootstrap ISO]

> The ISO image holds the Nix store for the live environment and also acts as a binary cache to the installer. To considerably speed things up, the image already includes all flake inputs as well as the devshell closures.

## Setup

```sh
nix run github:nix-community/nixos-generators -- \
  --format install-iso \
  --flake 'github:WeebSorceress/.dotfiles/main#bootstrap'
```

[Bootstrap ISO]: https://digga.divnix.com/start/iso.html
