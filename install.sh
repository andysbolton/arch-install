#!/bin/bash

set -e

interface=$(iw dev | awk '$1=="Interface"{print $2}')

read -r -p "Enter hostname: " host
# read -r -p "Enter SSID: " ssid
# read -r -p "Enter network passphrase: " passphrase

# iwctl --passphrase "$passphrase" station "$interface" connect "$ssid"
#
# echo "Updating system clock..."
# timedatectl set-ntp true
#
# echo "Optimizing mirror list..."
# reflector -c 'US' -a 15 -p https --sort rate --save /etc/pacman.d/mirrorlist
# pacman -Syy
#
# echo "Installing base system..."
# pacstrap /mnt base base-devel linux linux-firmware \
#     neovim less which man-db man-pages intel-ucode \
#     wpa_supplicant fish iw git
#
# echo "Generating fstab..."
# genfstab -U /mnt >>/mnt/etc/fstab
#
cp chroot-install.sh /mnt/chroot-install.sh
echo "chroot into new system"
arch-chroot /mnt "./chroot-install.sh" "$host" "$SSID" "$PASSPHRASE"
rm /mnt/chroot-install.sh

echo "Setting stub link for systemd-resolved..."
ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

echo "Setup finished. To complete, run umount -R /mnt and reboot."
