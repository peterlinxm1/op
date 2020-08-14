#!/bin/bash
#=============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Lisence: MIT
# Author: P3TERX
#=============================================================

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default
#sed -i 's/\"#src-git\"/\"src-git\"/g' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


# Add program/luci-app/theme（use to /.config luci-app&theme）install to openwrt/package
svn co https://github.com/ophub/op/trunk/router/phicomm_n1/install-program package/install-program
svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-bootstrap-mod package/luci-theme-bootstrap-mod
#svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-argon-dark-mod package/luci-theme-argon-dark-mod
#svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-argon-light-mod package/luci-theme-argon-light-mod


#other
#rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}

