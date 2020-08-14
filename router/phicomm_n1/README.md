# OpenWrt for Phicomm-N1 Firmware instructions


You can download the OpwnWrt for Phicomm N1 firmware from [Actions](https://github.com/ophub/op/actions). From the `Build Phicomm N1 OpenWrt Firmware`, Such as `***-phicomm-n1-v5.4.50-openwrt-firmware`. Unzip it to get the IMG file, and write the IMG file to the USB hard disk through software such as [balenaEtcher](https://www.balena.io/etcher/).

The firmware supports USB hard disk booting. You can also flash the firmware in the USB hard disk into the EMMC partition of Phicomm N1, and start using it from N1.

Writing method: `log in to openwrt` > `system menu` > `TTYD terminal` > input command: `n1-install`, you can input the firmware in the USB hard disk to the EMMC partition of Phicomm N1.

Update method: `log in to openwrt` > `system menu` > `file transfer` > upload to /tmp/upgrade/xxx.img, enter the `system menu` > `TTYD terminal` and use the command `n1-update` to update the firmware.

```text
Note: If used as a bypass gateway, you can add custom firewall rules as needed (Network -> Firewall -> Custom Rules):
  iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
You can also try (when there is a bridge): 
  iptables -t nat -I POSTROUTING -o  br-lan -j MASQUERADE
```


# Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |
