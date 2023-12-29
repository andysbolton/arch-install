#!/bin/bash

set -ex

sfdisk /dev/sda <./sda.fdisk

mkfs.fat -F32 -n BOOT/dev/sda1
mkfs.ext4 -n SWAP /dev/sda2
mkfs.ext4 -n ROOT /dev/sda3
mkfs.ext4 -n HOME /dev/sda4

mkswap -L SWAP /dev/sda2
swapon /dev/sda2

mount /dev/sda3 /mnt
mount --mkdir /dev/sda4 /mnt/home
mount --mkdir /dev/sda1 /mnt/boot
