#!/bin/bash

set -e

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
sed "s/%HOSTNAME%/$host/g" etc/hosts /etc/hosts

echo "Setting root password..."
passwd

echo "Installing bootloader..."
uuid=$(blkid -s UUID -o value /dev/sda3)
bootctl --path=/boot install
cp boot/loader/loader.conf /boot/loader/loader.conf
cp boot/loader/entries/arch.conf /boot/loader/entries/arch.conf
sed -i "s/%UUID%/$uuid/" /boot/loader/entries/arch.conf

echo "Setting up systemd-resoved..."
systemctl enable systemd-resolved.service

# Anticipating the change systemd will make to the interface name
interface="wlp2s0"

echo "Setting up systemd-networkd..."
wpa_passphrase "$ssid" "$passphrase" >"/etc/wpa_supplicant/wpa_supplicant-$interface.conf"
systemctl enable wpa_supplicant@"$interface"
sed "s/%INTERFACE%/$interface/" etc/systemd/network/default.network >/etc/systemd/network/default.network
systemctl enable systemd-networkd.service

echo "Exiting chroot..."
