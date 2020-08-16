# OP Introduction

The latest version of the OpenWrt firmware is automatically compiled every Friday at 0:00 UTC, Build OpenWrt using GitHub Actions, which can be downloaded in [Action](https://github.com/ophub/op/actions). For detailed information about each firmware, please refer to the README.md file of each model. The currently supported router models are: 

- [X64 Virtual Machine](https://github.com/ophub/op/tree/master/router/x64)
- [Linksys WRT1900ACS v1 & v2 (shelby)](https://github.com/ophub/op/tree/master/router/linksys_wrt1900acs_v2)
- [Phicomm N1](https://github.com/ophub/op/tree/master/router/phicomm_n1)

## Usage

* .github/workflow/***.yml files related environment variable description:

| Environment variable | Features |
| ---- | ---- |
| REPO_URL | Source code warehouse address |
| REPO_BRANCH | Source branch |
| FEEDS_CONF | Custom feeds.conf.default file name |
| CONFIG_FILE | Custom .config file name |
| DIY_P1_SH | Custom diy-part1.sh file name |
| DIY_P2_SH | Custom diy-part2.sh file name |
| SSH_ACTIONS | SSH connection Actions function. Default false |
| UPLOAD_BIN_DIR | Upload the bin directory (all ipk files and firmware). Default false |
| UPLOAD_FIRMWARE | Upload firmware catalog. Default true |
| UPLOAD_COWTRANSFER | Upload the firmware to CowTransfer.com. Default false |
| UPLOAD_WERANSFER | Upload the firmware to WeTransfer.com. Default failure |
| TZ | Time zone setting |

* Related script usage instructions:

There are currently two DIY scripts in the root directory of the warehouse: `diy-part1.sh`, `diy-part2.sh` and `.config`, which are executed before and after the update and installation of `./scripts/feeds update && ./scripts/feeds install`. You can write the instructions for modifying the source code into the script, such as modifying `the default IP , Host name, theme, add/remove software package...`, etc. If the additional software package has the same name as the existing software package in the Open­Wrt source code, the software package with the same name in the Open­Wrt source code needs to be deleted, otherwise the packages in Open­Wrt will be compiled first. It will automatically traverse all files in the `package` directory when compiling.


Just put the `feeds.conf.default` file into the root directory of the warehouse, it will overwrite the relevant files in the Open­Wrt source directory. Create a new `files` directory under the root directory of the warehouse, and put the customized related files in the same directory structure as OpenWrt, and the OpenWrt configuration will be overwritten during compilation.


Set `SSH_ACTIONS: true` to use tmate to connect to the `GitHub Ac­tions` virtual server environment. You can directly perform the `make menuconfig` operation to generate the compilation configuration, or any customized operation. After triggering the workflow, wait for the `SSH connection to Actions` step to be executed on the `Actions` page, and the following message will appear. Copy the SSH connection command and paste it into the terminal for execution, or copy the link to open it in the browser and use the web terminal. (The web terminal may encounter a black screen, just press `Ctrl+C`). After completion, press the shortcut key `Ctrl+D` or execute the `exit` command to exit, and the subsequent compilation work will proceed automatically.

Tips: The code Fork comes from the code bases of authors such as `coolsnowwolf, P3TERX & tuanqing...`, I only did a simple router adaptability debugging. After `Fork`, you can customize it by modifying `.yml, .config, diy-part1.sh, diy-part2.sh...` etc. For more advanced usage, please go to the original author's code base to learn.

* Catalog description:

```shell script

 ├── .github
 │   └── workflows                        
 │       ├── build-openwrt-linksys_wrt1900acs_v2.yml   # Build Linksys WRT1900ACS firmware
 │       ├── build-openwrt-x64.yml                     # Build X64 Virtual Machine firmware
 │       └── build-openwrt-phicomm_n1.yml              # Build PHICOMM N1 firmware
 │
 ├── router                                            # Related router Openwrt firmware codes 
 │   ├── linksys_wrt1900acs_v2                         # Linksys WRT1900ACS related code files
 │   │   ├── .config                                   # config luci-app, luci-theme and other
 │   │   ├── diy-part1.sh                              # DIY script part 1(Before Update feeds)
 │   │   ├── diy-part2.sh                              # DIY script part 2(After Update feeds)
 │   │   └── README.md                                 # Instructions
 │   │
 │   ├── x64                                           # x64 Virtual Machine related code files
 │   │   ├── .config            
 │   │   ├── diy-part1.sh            
 │   │   ├── diy-part2.sh
 │   │   └── README.md                                 # Instructions
 │   │
 │   └── phicomm_n1                                    # PHICOMM N1 related code files
 │       ├── .config            
 │       ├── diy-part1.sh            
 │       ├── diy-part2.sh            
 │       ├── make                                      # Build script for PHICOMM N1
 │       ├── README.md                                 # Instructions
 │       │
 │       └── armbian                                   # armbian related files
 │           ├── boot-common.tar.gz                    # Public startup file
 │           ├── firmware.tar.gz                       # armbian firmware
 │           │
 │           ├── phicomm-n1
 │           │   ├── kernel                            # Custom kernel folder
 │           │   │   ├── 4.18.7                        # 4.18.7 kernel folder
 │           │   │   │   ├── kernel.tar.gz             # kernel zip file
 │           │   │   │   └── modules.tar.gz            # modules zip file
 │           │   │   │   
 │           │   │   ├── 4.19.106                      # 4.19.106 kernel folder
 │           │   │   │   ├── kernel.tar.gz
 │           │   │   │   └── modules.tar.gz
 │           │   │   │  
 │           │   │   └── 5.4.50                        # 5.4.50 kernel folder
 │           │   │       ├── kernel.tar.gz
 │           │   │       └── modules.tar.gz
 │           │   │
 │           │   └── root                              # Add your custom files  
 │           │
 │           install-program                           # Install to emmc for PHICOMM N1
 │           ├── Makefile            
 │           │
 │           ├── files
 │           │   ├── fstab 
 │           │   ├── n1-install.sh                     # Install script
 │           │   ├── n1-update.sh                      # update script
 │           │   └── u-boot-2015-phicomm-n1.bin        # Recovery emmc partition script
 │           │
 │           lede-mod                                  # custom modification file
 │           ├── bootstrap                             # For luci-theme
 │           │   └── 0001-css.patch
 │           │
 │           └── luci                                  # For luci-app
 │               └── 0001-overview-add-cpu-info.patch 
 │
 ├── LICENSE                                           # LICENSE for OP
 └── README.md                                         # Instructions for OP
   
```

## Acknowledgments

- [OpenWrt](https://github.com/openwrt/openwrt)
- [Lean's OpenWrt](https://github.com/coolsnowwolf/lede)
- [Lienol's OpenWrt](https://github.com/Lienol/openwrt)

- [P3TERX's Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
- [tuanqing's mknop](https://github.com/tuanqing/mknop)
- [KFERMercer's OpenWrt-CI](https://github.com/KFERMercer/OpenWrt-CI)

- [GitHub Actions](https://github.com/features/actions)
- [Cowtransfer](https://cowtransfer.com)
- [WeTransfer](https://wetransfer.com/)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)

## License

[OP](https://github.com/ophub/op/blob/master/LICENSE) © OPHUB
