# OpenWrt for Phicomm-N1


You can download the OpwnWrt for Phicomm N1 firmware from [Actions](https://github.com/ophub/op/actions) and [Releases](https://github.com/ophub/op/releases). From the ` Build OpenWrt for Phicomm N1 `, Such as `***-phicomm-n1-v5.4.50-openwrt-firmware or other kernel versions.` Unzip to get the `***.img` file. Then write the IMG file to the USB hard disk through software such as [balenaEtcher](https://www.balena.io/etcher/).

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

Note: If used as a bypass gateway, you can add custom firewall rules as needed (Network → Firewall → Custom Rules):
```shell script
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE        #If the interface is eth0.
iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE      #If the interface is br-lan bridged.
```

# Local compilation instructions
The software package supports Github Action cloud compilation, and the compiled firmware can be downloaded directly in [Action](https://github.com/ophub/op/actions) and [Releases](https://github.com/ophub/op/releases). You can also compile locally:
1. Clone the warehouse to the local. `git clone https://github.com/ophub/op`
2. Create an `openwrt` folder in the local `op/router/phicomm_n1` directory, and upload the compiled openwrt firmware of the ARM kernel to the openwrt directory
3. Enter the phicomm_n1 directory and run `sudo ./make -d` to complete the compilation. The generated openwrt firmware supporting Phicomm N1 is in the `out` directory under the root directory.

# Detailed make compile command
- `sudo ./make -d`: Compile all kernel versions of openwrt with the default configuration. This command is recommended.
- `sudo ./make -d -s 512 -k 5.7.15`: Use the default configuration and set the partition size to 512m, and only compile the openwrt firmware with the kernel version 5.7.15.
- `sudo ./make`: If you are familiar with the relevant setting requirements of the phicomm_n1 firmware, you can follow the prompts, such as selecting the firmware you want to make, the kernel version, setting the ROOTFS partition size, etc. If you don’t know these settings, just press Enter .

# Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | ARMv8 multiplatform |
| Target Profile | Default |
| Target Images | squashfs |
| Utilities  ---> |  <*> install-program |
| LuCI -> Applications | in the file: .config |

# Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |
