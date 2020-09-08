# install-program

Install to emmc script for phicomm n1, which will help you to copy openwrt system to emmc.

## Usage

The firmware supports USB hard disk booting. You can also Install the OpenWrt firmware in the USB hard disk into the EMMC partition of Phicomm N1, and start using it from N1.

Install OpenWrt: `Login in to openwrt` → `system menu` → `TTYD terminal` → input command: 
```shell script
n1-install.sh
# Wait for the installation to complete. remove the USB hard disk, unplug/plug in the power again, reboot into EMMC.
```

Upgrading OpenWrt: `Login in to openwrt` → `system menu` → `file transfer` → upload to `/tmp/upgrade/xxx.img`, enter the `system menu` → `TTYD terminal` → input command: 
```shell script
n1-update.sh
reboot          #Enter the reboot command to restart.
```
If the partition fails and cannot be written, you can restore the bootloader, restart it, and run the relevant command again.
```shell script
dd if=/root/u-boot-2015-phicomm-n1.bin of=/dev/mmcblk1
reboot
```
