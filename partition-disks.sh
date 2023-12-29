#!/bin/bash

set -ex

sfdisk /dev/sda <sda.sfdisk

mkfs.fat -F32 -n BOOT /dev/sda1
mkfs.ext4 -L ROOT /dev/sda3
mkfs.ext4 -L HOME /dev/sda4

mkswap -L SWAP /dev/sda2
swapon /dev/sda2

mount /dev/sda3 /mnt
mount --mkdir /dev/sda4 /mnt/home
mount --mkdir /dev/sda1 /mnt/boot
