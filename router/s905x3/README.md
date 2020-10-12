# OpenWrt for S905x3 ( X96 Max Plus, HK1 Box )

You can download the OpwnWrt for S905x3 firmware from [Actions](https://github.com/ophub/op/actions). From the ` Build OpenWrt for S905x3 `, Such as `openwrt_s905x3_${date}` Unzip to get the `***.img` file. Or download from [Releases](https://github.com/ophub/op/releases). Such as `openwrt_S905x3_${date}`. Then write the IMG file to the USB card/TF card  through software such as [balenaEtcher](https://www.balena.io/etcher/).

## Compilation instructions
1. Online automatic compilation: The script will regularly use the latest OpenWrt for phicomm-n1 firmware and modify ***` /boot/uEnv.txt `*** to build a compatible S905x3 series router.
2. Local manual compilation: First put the phicomm-n1 firmware into the ***` flippy `*** folder, and then run `sudo ./make ${firmware_key}`, the generated file is in the ***` out `*** directory.


## Firmware instructions

Decompress the firmware and write it to a MicroSD card/TF card. Before starting the USB flash drive for the first time, use the adb tool to connect:
```shell script
adb connect router ip
adb shell
su
reboot update
````
Then quickly insert the prepared USB card/TF card to start the openwrt for s905x3 firmware


The firmware supports USB hard disk booting. You can also Install the OpenWrt firmware in the USB hard disk into the EMMC partition of S905x3, and start using it from EMMC.

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
dd if=/root/hk1box-bootloader.img of=/dev/mmcblk1 bs=1M
sync
reboot
```

Note: If used as a bypass gateway, you can add custom firewall rules as needed (Network → Firewall → Custom Rules):
```shell script
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE        #If the interface is eth0.
iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE      #If the interface is br-lan bridged.
```

## /boot/uEnv.txt:

```shell script
#Phicomm N1
#FDT=/dtb/amlogic/meson-gxl-s905d-phicomm-n1.dtb
#Phicomm N1 (thresh)
#FDT=/dtb/amlogic/meson-gxl-s905d-phicomm-n1-thresh.dtb
#
#X96 Max+ (S905X3 for 100m)
#FDT=/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb
#X96 Max+ (S905X3 for 1000M) [tag: s905x3]
FDT=/dtb/amlogic/meson-sm1-x96-max-plus.dtb
#
#HK1 BoX (S905X3 for 1000M) [tag: hk1]
#FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb
````

Method: Add # in front of the dtb file path of Phicomm N1, and remove the # in front of the firmware you need. Start from usb is to use ***` meson-sm1-x96-max-plus-100m.dtb `***, and change to ***` meson-sm1-x96-max-plus.dtb `*** after writing emmc.

## Detailed make compile command
- `sudo ./make all`: All S905x3 (X96 Max Plus, HK1 Box) OpenWrt firmware according to the default configuration firmware. This command is recommended.
- `sudo ./make x96`: Build the OpenWrt firmware of X96 Max Plus according to the default configuration.
- `sudo ./make hk1`: Build the OpenWrt firmware of HK1 Box according to the default configuration.

## Configuration file function description

| Folder/file name | Features |
| ---- | ---- |
| .config | Firmware related configuration, such as firmware kernel, file type, software package, luci-app, luci-theme, etc. |
| files | Create a files directory under the root directory of the warehouse and put the relevant files in. You can use custom files such as network/dhcp/wireless by default when compiling. |
| feeds.conf.default | Just put the feeds.conf.default file into the root directory of the warehouse, it will overwrite the relevant files in the OpenWrt source directory. |
| diy-part1.sh | Execute before updating and installing feeds, you can write instructions for modifying the source code into the script, such as adding/modifying/deleting feeds.conf.default. |
| diy-part2.sh | After updating and installing feeds, you can write the instructions for modifying the source code into the script, such as modifying the default IP, host name, theme, adding/removing software packages, etc. |
| make | Phicomm N1 OpenWrt firmware build script. |
| armbian | Multi-version kernel file directory. |
| build-n1-kernel | Use the kernel file shared by Flippy to build this script to build the Armbian kernel of OpenWrt for Phicomm-N1. |
| install-program | Script to flash firmware to emmc. |


## .github/workflow/build-openwrt-s905x3.yml related environment variable description

| Environment variable | Features |
| ---- | ---- |
| REPO_URL | Source code warehouse address |
| REPO_BRANCH | Source branch |
| FEEDS_CONF | Custom feeds.conf.default file name |
| CONFIG_FILE | Custom .config file name |
| DIY_P1_SH | Custom diy-part1.sh file name |
| DIY_P2_SH | Custom diy-part2.sh file name |
| SSH_ACTIONS | SSH connection Actions function. Default false |
| UPLOAD_BIN_DIR | Upload the bin directory (all ipk files and firmware). Default false |
| UPLOAD_FIRMWARE | Upload firmware catalog. Default true |
| UPLOAD_RELEASE | Upload firmware to release. Default true |
| UPLOAD_COWTRANSFER | Upload the firmware to CowTransfer.com. Default false |
| UPLOAD_WERANSFER | Upload the firmware to WeTransfer.com. Default failure |
| TZ | Time zone setting |
| secrets.GITHUB_TOKEN | 1. Personal center: Settings → Developer settings → Personal access tokens → Generate new token ( Name: GITHUB_TOKEN, Select: public_repo, Copy GITHUB_TOKEN's Value ). 2. Op code center: Settings → Secrets → New secret ( Name: RELEASES_TOKEN, Value: Paste GITHUB_TOKEN's Value ). |

## Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | QEMU ARM Virtual Machine |
| Subtarget | ARMv8 multiplatform |
| Target Profile | Default |
| Target Images | squashfs |
| Utilities  ---> |  <*> install-program |
| LuCI -> Applications | in the file: .config |

## Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |

