# OpenWrt for x64

You can download the OpwnWrt for x64 firmware from [Actions](https://github.com/ophub/op/actions). Such as, ` Build OpenWrt for x64 `, Unzip to get the `***.img` file.


The firmware can be followed to [VMware ESXi](https://www.vmware.com/products/esxi-and-esx.html), [Parallels Desktop](http://www.parallels.cn/products/desktop/), [Synology's Virtual Machine Manager](https://www.synology.cn/en-global/dsm/feature/virtual_machine_manager) and other virtual host systems, as well as various physical hosts of x64 architecture. For specific installation methods, please refer to the installation instructions of each system.

VMware ESXi Install OpenWrt firmware conversion commands:
```shell script
sudo apt-get install qemu               #mac: brew install qemu
qemu-img convert -f raw -O vmdk openwrt-x86-64-generic-ext4-combined.img openwrt-x86-64-generic-ext4-combined.vmdk
```

Parallels Desktop Install OpenWrt firmware conversion commands:
```shell script 
sudo apt-get install qemu               #mac: brew install qemu
qemu-img convert -f raw -O vmdk openwrt-x86-64-generic-ext4-combined.vmdk openwrt-x86-64-generic-ext4-combined.hdd
```
Synology's Virtual Machine Manager Install OpenWrt:
```text
Login in to Synology: Virtual Machine Manager → Image → Add → Upload the .img file (openwrt-x86-64-generic-squashfs-combined.img)
```

# Firmware compilation parameters

| Option | Value |
| ---- | ---- |
| Target System | x86 |
| Subtarget | x64 64bit |
| Target Profile | Generic |
| Target Images | squashfs |
| LuCI -> Applications | in the file: .config |

# Firmware information

| Name | Value |
| ---- | ---- |
| Default IP | 192.168.1.1 |
| Default username | root |
| Default password | password |
| Default WIFI name | OpenWrt |
| Default WIFI password | none |
