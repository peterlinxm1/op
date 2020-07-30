#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# later feeds
#============================================================

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate


# install to lede/package/openwrt-packages(mkdirFolder)
#cd package
#mkdir openwrt-packages
#cd openwrt-packages
# ==========luci-app-url==========
# git clone https://github.com/kenzok8/openwrt-packages.git
# git clone https://github.com/kenzok8/small.git
# git clone https://github.com/fw876/helloworld.git
# ==========luci-theme-url==========
#git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git
# install to lede
#cd ../../

git clone https://github.com/tuanqing/lede-mod

echo "patching feeds luci"
git apply lede-mod/luci/*.patch --directory=feeds/luci
[ $? = 0 ] || echo "failed"

echo "patching luci-theme-bootstrap-mod"
git apply lede-mod/bootstrap/*.patch --directory=package/luci-theme-bootstrap-mod
[ $? = 0 ] || echo "failed"


zzz="package/lean/default-settings/files/zzz-default-settings"
sed -i 's/samba/samba4/' $zzz
sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' $zzz
sed -i "/openwrt_luci/i sed -i '/Lienol/d' /etc/opkg/distfeeds.conf" $zzz
sed -i "/openwrt_luci/i sed -i '/helloworld/d' /etc/opkg/distfeeds.conf" $zzz

packages=" \
brcmfmac-firmware-43430-sdio brcmfmac-firmware-43455-sdio kmod-brcmfmac wpad \
kmod-fs-ext4 kmod-fs-vfat kmod-fs-exfat dosfstools e2fsprogs antfs-mount \
kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas \
kmod-usb-net kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152 \
blkid lsblk parted fdisk losetup lscpu htop iperf3 curl \
lm-sensors install-program 
"

sed -i '/FEATURES+=/ { s/cpiogz //; s/ext4 //; s/ramdisk //; s/squashfs //; }' \
    target/linux/armvirt/Makefile
for x in $packages; do
    sed -i "/DEFAULT_PACKAGES/ s/$/ $x/" \
        target/linux/armvirt/Makefile
done


