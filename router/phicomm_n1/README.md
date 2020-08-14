# OpenWrt for Phicomm-N1 Firmware instructions


You can download the OpwnWrt for Phicomm N1 firmware from [Actions](https://github.com/ophub/op/actions). From the `Build Phicomm N1 OpenWrt Firmware`, Such as `***-phicomm-n1-v5.4.50-openwrt-firmware or other kernel versions`. Unzip it to get the IMG file, and write the IMG file to the USB hard disk through software such as [balenaEtcher](https://www.balena.io/etcher/).

The firmware supports USB hard disk booting. You can also flash the firmware in the USB hard disk into the EMMC partition of Phicomm N1, and start using it from N1.

Writing method: `Sign in to openwrt` > `system menu` > `TTYD terminal` > input command: 
```shell script
n1-install
reboot       #Pull out the USB hard disk, and then enter the reboot command to restart
```

Update method: `Sign in to openwrt` > `system menu` > `file transfer` > upload to /tmp/upgrade/xxx.img, enter the `system menu` > `TTYD terminal` > input command: 
```shell script
n1-update
reboot       #Pull out the USB hard disk, and then enter the reboot command to restart
```

Note: If used as a bypass gateway, you can add custom firewall rules as needed (Network -> Firewall -> Custom Rules):
```shell script
iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE        #If the interface is eth0.
iptables -t nat -I POSTROUTING -o br-lan -j MASQUERADE      #If the interface is br-lan bridged.
```
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
