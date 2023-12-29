#!/bin/bash

set -e

interface=$(iw dev | awk '$1=="Interface"{print $2}')

if [ -z "$PASSPHRASE" ]; then
    echo "PASSPHRASE is not set."
    exit 1
fi

if [ -z "$SSID" ]; then
    echo "SSID is not set."
    exit 1
fi

read -r -p "Enter hostname: " host

iwctl --passphrase "$PASSPHRASE" station "$interface" connect "$SSID"

echo "Updating system clock..."
timedatectl set-ntp true

echo "Optimizing mirror list..."
reflector -c 'US' -a 15 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy

echo "Installing base system..."
pacstrap /mnt base base-devel linux linux-firmware \
    neovim less which man-db man-pages intel-ucode \
    wpa_supplicant fish iw git

echo "Generating fstab..."
genfstab -U /mnt >>/mnt/etc/fstab

cp chroot-install.sh /mnt/setup/chroot-install.sh
cp -r boot/ /mnt/setup/boot/
cp -r etc/ /mnt/setup/etc/
echo "chroot into new system"
arch-chroot /mnt "cd setup && ./chroot-install.sh" "$host" "$SSID" "$PASSPHRASE"
rm -rf /mnt/setup

echo "Setting stub link for systemd-resolved..."
ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

echo "Setup finished. To complete, run umount -R /mnt and reboot."
