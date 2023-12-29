# arch-install

Personal script for setting up Arch Linux.

# Steps

1. Boot into live environment

2. Connect to the internet

```bash
iwctl --passphrase "$passphrase" station "$interface" connect "$ssid"
```

3. Clone this repo

```bash
git clone https://github.com/andysbolton/arch-install
cd arch-install
```

4. Partition the disks

This script assumes a four-partition scheme like below.
Run `partition-disk.sh` if using my Dell Latitude E6320, which is hardcoded to add the following partitions:

| disk      | size     | partition type   | mount  | filetype |
| --------- | -------- | ---------------- | ------ | -------- |
| /dev/sdx1 | 512MB    | EFI System       | /boot  | fat32    |
| /dev/sdx2 | (2x RAM) | Linux swap       | [SWAP] | ext      |
| /dev/sdx3 | 25GB     | Linux fileystem  | /      | ext      |
| /dev/sdx4 | 195.4G   | Linux filesystem | /home  | ext      |

5. Run `install.sh`
   This script will:
