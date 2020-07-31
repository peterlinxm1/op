#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile
# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

# Mydiy-luci-app-and-theme（use to /.config luci-app&theme）
# cd package
# mkdir openwrt-packages
# cd openwrt-packages
# ==========luci-app-url==========
# git clone https://github.com/kenzok8/openwrt-packages.git
# git clone https://github.com/kenzok8/small.git
# git clone https://github.com/fw876/helloworld.git
# ==========luci-theme-url==========
# git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git
