# OpenWrt for s905x3 ( X96 Max Plus, HK1 Box )

Compilation instructions
1. Online automatic compilation: The script will regularly use the latest phicomm-n1 firmware and modify `/boot/uEnv.txt` to build a compatible s905x3 series router.
2. Local manual compilation: First put the phicomm-n1 firmware into the `flippy` folder, and then run `sudo ./make ${firmware_key}`, the generated file is in the `out` directory.


## Firmware instructions

Decompress the firmware and write it to a MicroSD card/TF card. Before starting the USB flash drive for the first time, use the adb tool to connect:
```shell script
adb connect router ip
adb shell
su
reboot update
````
Then quickly insert the prepared MicroSD card/TF card to start the openwrt for s905x3 firmware


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
#FDT=/dtb/amlogic/meson-sm1-x96-max-plus.dtb
#
#HK1 BoX (S905X3 for 1000M) [tag: hk1]
FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb
````

Method: Add # in front of the dtb file path of Phicomm N1, and remove the # in front of the firmware you need. E.g

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


## .github/workflow/build-openwrt-phicomm_n1.yml related environment variable description

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

