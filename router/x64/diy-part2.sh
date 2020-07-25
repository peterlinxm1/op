#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
# 此页脚本在更新与安装 feeds 后执行
#============================================================

# Modify default IP（192.168.1.1改为192.168.31.4）
#sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate


# Mydiy-luci-app-and-theme（use to /.config luci-app&theme）
cd package
mkdir openwrt-packages
cd openwrt-packages
# ==========luci-app-url==========
# git clone https://github.com/kenzok8/openwrt-packages.git
# git clone https://github.com/kenzok8/small.git
# git clone https://github.com/fw876/helloworld.git
# ==========luci-theme-url==========
git clone https://github.com/openwrt-develop/luci-theme-atmaterial.git
