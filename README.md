# arch-install

Personal scripts for setting up Arch Linux.

# Steps

1. Boot into live environment

2. Connect to the internet

```bash
# exporting these as they're used by the install.sh script
export PASSPHRASE="passphrase"
export SSID="ssid"
interface="interface" # can be retrieved by `ip link` or `iw dev | awk '$1=="Interface"{print $2}'`
iwctl --passphrase "$PASSPHRASE" station "$interface" connect "$SSID"
```

3. Clone this repo

```bash
pacman -Syy git
git clone https://github.com/andysbolton/arch-install
cd arch-install
```

4. Partition the disks

The `install.sh` script assumes a four-partition scheme like below.

Run `partition-disk.sh` if using my Dell Latitude E6320 (nb this will wipe the disk!!!). The script is hardcoded to add the following partitions:

| disk      | size          | partition type   | mount  | filetype |
| --------- | ------------- | ---------------- | ------ | -------- |
| /dev/sdx1 | 512MB         | EFI System       | /boot  | fat32    |
| /dev/sdx2 | 16GB (2x RAM) | Linux swap       | [SWAP] | ext      |
| /dev/sdx3 | 25GB          | Linux fileystem  | /      | ext      |
| /dev/sdx4 | 195.4G        | Linux filesystem | /home  | ext      |

5. Run `install.sh`

   This script will:
