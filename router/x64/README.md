# OpenWrt for x64

You can download the OpwnWrt for x64 firmware from [Actions](https://github.com/ophub/op/actions). Such as, ` Build OpenWrt for x64 `, Unzip to get the `***.img` file.


The firmware can be followed to [VMware ESXi](https://www.vmware.com/products/esxi-and-esx.html), [Parallels Desktop](http://www.parallels.cn/products/desktop/), [Synology Virtual Machine Manager](https://www.synology.cn/en-global/dsm/feature/virtual_machine_manager) and other virtual host systems, as well as various physical hosts of x64 architecture. For specific installation methods, please refer to the installation instructions of each system.

VMware ESXi firmware conversion commands:
````shell script 
sudo apt-get install qemu
qemu-img convert -f raw -O vmdk openwrt-x86-64-generic-combined-ext4.img openwrt-x86-64-generic-combined-ext4.vmdk
````

Parallels Desktop firmware conversion commands:
````shell script 
sudo apt-get install qemu
qemu-img convert -f raw -O vmdk openwrt-x86-64-generic-combined-ext4.vmdk openwrt-x86-64-generic-combined-ext4.hdd
````


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
