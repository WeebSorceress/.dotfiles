#! /usr/bin/env sh

set -euo pipefail

export DISK1=$1
export DISK2=$2
export DISK=($DISK1 $DISK2)
export HOST=$3
export SWAP=$4
export BOOT=$5
export FLAKE="github:WeebSorceress/.dotfiles/main"

export RED_BG="\033[41m"
export BLUE_BG="\033[44m"
export RESET_BG="\033[0m"

function err {
  echo -e "\n${RED_BG}$1${RESET_BG}\n"
}

function info {
  echo -e "\n${BLUE_BG}$1${RESET_BG}\n"
}

if [[ "$EUID" > 0 ]]; then
  err "Must run as root."
  exit 1
fi

if ! [[ -v DISK ]]; then
  err "Missing argument. Expected block device name, e.g. '/dev/disk/by-id/ata-P4-120_9D20106004931 /dev/disk/by-id/ata-P4-120_9D20106004951'."
  exit 1
fi

if ! [[ -v HOST ]]; then
  err "Missing argument. Expected host/machine name, e.g. 'suzumiya'."
  exit 1
fi

if ! [[ -v SWAP ]]; then
  err "Missing argument. Expected swap size, e.g. '4GiB'."
  exit 1
fi

if ! [[ -v BOOT ]]; then
  err "Missing argument. Expected boot size, e.g. '1024MiB'."
  exit 1
fi

function cleanup {
  for x in "${DISK[@]}"; do
    info "Running cleanup steps on '$x' ..."
    sgdisk --zap-all $x
    sleep 2
  done
}

function partition {
  for x in "${DISK[@]}"; do
    info "Running the UEFI (GPT) partitioning and formatting directions from the NixOS manual on '$x' ..."
    parted "$x" -- mklabel gpt
    parted "$x" -- mkpart primary $BOOT -$SWAP
    parted "$x" -- mkpart primary linux-swap -$SWAP 100%
    parted "$x" -- mkpart ESP fat32 1MiB $BOOT
    parted "$x" -- set 3 esp on

    sleep 2

    mkswap -L swap "${x}-part2"
    swapon "${x}-part2"

    mkfs.fat -F 32 -n EFI "${x}-part3"
  done
}

function zfs_setup {
  export ZFS_POOL="rpool"
  export ZFS_NIXOS="${ZFS_POOL}/nixos"
  export ZFS_DS_ROOT="${ZFS_NIXOS}/root"
  export ZFS_DS_NIX="${ZFS_NIXOS}/nix"
  export ZFS_DS_PERSIST="${ZFS_NIXOS}/persist"
  export ZFS_BLANK_SNAPSHOT="${ZFS_DS_ROOT}@blank"
  export ZFS_RESERVATION="${ZFS_POOL}/reserved"
}

function zfs_install {
  info "Creating ZFS pool '$ZFS_POOL' for '${DISK[@]/%/-part1}' ..."
  zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O canmount=off \
    -O mountpoint=none \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O encryption=aes-256-gcm \
    -O keylocation=prompt \
    -O keyformat=passphrase \
    rpool \
    mirror \
    "${DISK[@]/%/-part1}"

  zfs create "$ZFS_NIXOS"

  info "Creating '$ZFS_DS_ROOT' ZFS dataset ..."
  zfs create -o canmount=on -o xattr=sa -o acltype=posixacl "$ZFS_DS_ROOT"

  info "Creating '$ZFS_BLANK_SNAPSHOT' ZFS snapshot ..."
  zfs snapshot "$ZFS_BLANK_SNAPSHOT"

  info "Mounting '$ZFS_DS_ROOT' to /mnt ..."
  mount -t zfs -o zfsutil "$ZFS_DS_ROOT" /mnt

  mkdir /mnt/boot /mnt/boot-mirror
  info "Mounting '${DISK[0]}-part3' to /mnt/boot ..."
  mount "${DISK[0]}-part3" /mnt/boot

  sleep 1

  info "Mounting '${DISK[1]}-part3' to /mnt/boot-mirror ..."
  mount "${DISK[1]}-part3" /mnt/boot-mirror

  info "Creating '$ZFS_DS_NIX' ZFS dataset ..."
  zfs create -o canmount=on -o atime=off "$ZFS_DS_NIX"

  info "Mounting '$ZFS_DS_NIX' to /mnt/nix ..."
  mkdir /mnt/nix
  mount -t zfs -o zfsutil "$ZFS_DS_NIX" /mnt/nix

  info "Creating '$ZFS_DS_PERSIST' ZFS dataset ..."
  zfs create -o canmount=on "$ZFS_DS_PERSIST"

  info "Mounting '$ZFS_DS_PERSIST' to /mnt/persist ..."
  mkdir /mnt/persist
  mount -t zfs -o zfsutil "$ZFS_DS_PERSIST" /mnt/persist

  info "Permit ZFS auto-snapshots on '$ZFS_DS_PERSIST' dataset ..."
  zfs set com.sun:auto-snapshot=true "$ZFS_DS_PERSIST"

  info "Create 1 GiB reservation at '$ZFS_RESERVATION' ..."
  zfs create -o refreservation=1G "$ZFS_RESERVATION"
}

info "Disk cleanup routine ..."
cleanup

info "Disk partition routine ..."
partition

info "Setting up ZFS schemes ..."
zfs_setup

zfs_install

info "NixOS Installation: Starting..."
nixos-install --no-root-passwd --flake $FLAKE#$HOST

info "Unmounting '${DISK[0]}-part3' on /mnt/boot ..."
umount /mnt/boot

info "Unmounting '${DISK[1]}-part3' on /mnt/boot-mirror ..."
umount /mnt/boot-mirror

info "Exporting "$ZFS_POOL" pool ..."
zpool export "$ZFS_POOL"

info "NixOS Installation: Complete"
