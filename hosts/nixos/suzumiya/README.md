# [Suzumiya][Suzumiya]

> Haruhi [Suzumiya][Suzumiya] is the founding member of the SOS Brigade with the purpose of finding aliens, time travelers and espers. She is incredibly eccentric and usually anti-social, with no interest in "ordinary" humans.

## Setup

### Install (with [Bootstrap ISO](../bootstrap/README.md))

```sh
nixy-zfs-install \
  '/dev/disk/by-id/ata-P4-120_9D20106004931' \ # Default Disk
  '/dev/disk/by-id/ata-P4-120_9D20106004951' \ # Mirrored Disk
  'suzumiya' \ # Hostname
  '2GiB' \ # Swap Partition (on each disk)
  '512MiB' # Boot Partition (on each disk)
```

### Rebuild

```sh
nixos-rebuild switch --flake 'github:WeebSorceress/.dotfiles/main#suzumiya'
```

[Suzumiya]: https://anilist.co/character/251/Suzumiya-Haruhi
