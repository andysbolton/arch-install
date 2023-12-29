#!/bin/bash

host="$1"
ssid="$2"
passphrase="$3"

echo "Setting timezone..."
ln -sf /usr/share/zoneinfo/US/Mountain /etc/localtime

hwclock --systohc

echo "Setting locale..."
sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf

echo "Setting hostname..."
echo "$host" >/etc/hostname
sed "s/HOSTNAME/$host/g" etc/hosts /etc/hosts

echo "Setting root password..."
passwd

echo "Installing bootloader..."
bootctl --path=/boot install
cp boot/loader/loader.conf /boot/loader/loader.conf
cp boot/loader/entries/arch.conf /boot/loader/entries/arch.conf

echo "Setting up systemd-resoved..."
# We'll create the following symlink outside of the chroot once we've exited it at the end of the script.
# Otherwise, per https://wiki.archlinux.org/title/Systemd-resolved, the link won't be persisted.
# ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf
systemctl enable systemd-resolved.service

# Requery the interface name as systemd is now in use which alters it.
interface=$(iw dev | awk '$1=="Interface"{print $2}')

echo "Setting up systemd-networkd..."
wpa_passphrase "$ssid" "$passphrase" >"/etc/wpa_supplicant/wpa_supplicant-$interface.conf"
systemctl enable wpa_supplicant@"$interface"
sed "s/INTERFACE/$interface/" etc/systemd/network/default.network >/etc/systemd/network/default.network
systemctl enable systemd-networkd.service

echo "Exiting chroot..."
