# OP Introduction

The latest version of the OpenWrt firmware is automatically compiled every Friday at 0:00 UTC, Build OpenWrt using GitHub Actions, which can be downloaded in [Action](https://github.com/ophub/op/actions). For detailed information about each firmware, please refer to the README.md file of each model. The currently supported router models are: 

- [X64 Virtual Machine](https://github.com/ophub/op/tree/master/router/x64)
- [Linksys WRT1900ACS v1 & v2 (shelby)](https://github.com/ophub/op/tree/master/router/linksys_wrt1900acs_v2)
- [Phicomm N1](https://github.com/ophub/op/tree/master/router/phicomm_n1)

# Usage

* Catalog description:
```shell script **
   ├── .github
   │   └── workflows                        
   │   │   ├── build-openwrt-linksys_wrt1900acs_v2.yml     # Automatically Build OpenWrt Firmware for Linksys WRT1900ACS
   │   │   ├── build-openwrt-phicomm_n1.yml                # Automatically Build OpenWrt Firmware for PHICOMM N1
   │   │   ├── build-openwrt-x64.yml                       # Automatically Build OpenWrt Firmware for X64 Virtual Machine
   │   └── .gitkeep
   ├── router
   │   ├── linksys_wrt1900acs_v2                           # Linksys WRT1900ACS related code files
   │   │   ├── .config                                     # For configuration, luci-app, luci-theme and other
   │   │   ├── README.md            
   │   │   ├── diy-part1.sh                                # OpenWrt DIY script part 1 (Before Update feeds)
   │   │   └── diy-part2.sh                                # OpenWrt DIY script part 2 (After Update feeds)
   │   └── x64                        
   │   │   ├── .config            
   │   │   ├── README.md            
   │   │   ├── diy-part1.sh            
   │   │   ├── diy-part2.sh
   │   └── phicomm_n1                        
   │       ├── .config            
   │       ├── README.md            
   │       ├── diy-part1.sh            
   │       ├── diy-part2.sh            
   │       ├── make                                        # OpenWrt Firmware for PHICOMM N1 build script
   │       └── armbian                                     # armbian related files
   │           ├── phicomm-n1
   │           │   ├── boot-common.tar.gz                  # Public startup file
   │           │   ├── firmware.tar.gz                     # armbian firmware
   │           │   ├── kernel                              # Custom kernel folder
   │           │   │   ├── 4.18.7   
   │           │   │   ├── 4.19.106                  
   │           │   │   └── 5.4.50   
   │           │   └── root                                # Add your custom file
   │           │       └── .gitkeep  
   │           install-program                             # Install to emmc script for phicomm n1
   │           ├── Makefile            
   │           ├── files
   │           │   ├── fstab 
   │           │   ├── n1-install.sh                       # Install script(command: n1-install.sh)
   │           │   ├── n1-update.sh                        # update script(command: n1-update.sh)
   │           │   └── u-boot-2015-phicomm-n1.bin          # Recovery emmc partition script(command: dd if=/root/u-boot-2015-phicomm-n1.bin of=/dev/mmcblk1)
   │           lede-mod                                    # Openwrt firmware custom modification file
   │           ├── bootstrap                               # For luci-theme
   │           │   └── 0001-css.patch
   │           └── luci                                    # For luci-app
   │               └── 0001-overview-add-cpu-info.patch 
   ├── .gitignore
   ├── LICENSE            
   └── README.md
   
```
* work­flow file related environment variable description:


## Acknowledgments & Tips

This is just a simple fork from the code base of authors such as P3TERX, Please go to the official code base for specific usage. 

- [P3TERX's Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [tuanqing's mknop](https://github.com/tuanqing/mknop)
- [KFERMercer's OpenWrt-CI](https://github.com/KFERMercer/OpenWrt-CI)

- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean's OpenWrt](https://github.com/coolsnowwolf/lede)
- [Lienol's OpenWrt](https://github.com/Lienol/openwrt)

- [GitHub Actions](https://github.com/features/actions)
- [csexton/debugger-action](https://github.com/csexton/debugger-action)
- [Cowtransfer](https://cowtransfer.com)
- [WeTransfer](https://wetransfer.com/)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)

## License

[OP](https://github.com/ophub/op/blob/master/LICENSE) © OPHUB
