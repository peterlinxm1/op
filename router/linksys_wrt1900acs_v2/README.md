# OpenWrt for Linksys WRT1900ACS Firmware instructions


You can download the OpwnWrt for Linksys WRT1900ACS firmware from [Actions](https://github.com/ophub/op/actions). Such as `Build Linksys WRT1900ACS v1 & v2 (shelby) OpenWrt Firmware`. Unzip to get the `***.img` file.

Installation method: Sign in to the Linksys WRT1900ACS management center (default ip: 192.168.1.1): `Access Router` (default password admin) > `connectivity` > `Basic` > `Manual` - `Choose File`, select the decompressed firmware: `openwrt-mvebu-cortexa9-linksys_wrt1900acs-squashfs-factory.img`, click `install`, wait for the installation to complete, the router will automatically restart and enter OpenWrt system.

Since Linksys WRT1900ACS has dual partitions, it is recommended that you keep the original firmware on one partition and install OpenWrt firmware on the other partition. These two partitions can be switched freely.

Enter the following command to view the partition (You can view it from OpenWrt `system menu` > `TTYD terminal`, or Using SSH tools such as `PuTTY` or `MAC Terminal`...): 
```shell script
fw_printenv boot_part     #if it displays: boot_part=2, it means the current firmware is in the second partition. 
fw_setenv boot_part 1     #Enter the command, you can switch to the first partition,  
reboot                    #enter the restart command to enter the firmware.
````

Due to the dual-partition design mechanism of Linksys WRT1900ACS, the contents of another partition will be overwritten every time the firmware is installed (rather than the partition where the currently logged-in firmware is installed), so every time you install or update OpenWrt, ***` please switch to the official firmware partition first. Refer to the installation method to install `***.

If you accidentally install both partitions as OpenWrt and want to restore one partition to the original firmware, you can restore it by referring to the following method:

Sign in to openwrt > `system menu` > `file transfer` > `upload`, and upload [the original firmware file of Linksys wrt1900 ACS](https://www.linksys.com/us/support-article?articleNum=165487) as [FW_WRT1900ACSV2_2.0.3.201002_prod.img](https://downloads.linksys.com/support/assets/firmware/FW_WRT1900ACSV2_2.0.3.201002_prod.img), 
Upload to `/tmp/upload/`, in the `system menu` > `TTYD terminal` > enter the commands in sequence:
```shell script
cd /tmp/upload
sysupgrade -F -n -v FW_WRT1900ACSV2_2.0.3.201002_prod.img
reboot
````


# Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | marvell EBU Armada |
| Subtarget | Marvell Armada 37x/38x/XP |
| Target Profile | Linksys WRT1900ACS (Shelby) |
| Target Images | squashfs |
| LuCI -> Applications | in the file: .config |



This firmware only supports WRT1900ACS v1 & v2 (shelby), other versions can be modified and compiled by referring to the firmware parameters. Other version firmware code:

| Model | Code |
| ---- | ---- |
| WRT1900AC v1 | mamba |
| WRT1900AC v2 | cobra |
| WRT1200AC | caiman |
| WRT1900ACS | shelby |



# Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |
