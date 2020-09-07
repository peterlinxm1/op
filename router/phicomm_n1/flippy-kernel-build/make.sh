#!/bin/bash

#=================================================================================
# https://github.com/ophub/op
# Description: Automatically Build OpenWrt for Phicomm N1
# Function: Use Flippy's kernel files build kernel.tar.xz & modules.tar.xz
# Copyright (C) 2020 https://github.com/ophub/op
#=================================================================================

# example: ~/op/router/phicomm_n1/flippy-kernel-build/
# ├── flippy
# │   ├── boot-5.7.15-flippy-41+.tar.gz
# │   ├── dtb-amlogic-5.7.15-flippy-41+.tar.gz
# │   └── modules-5.7.15-flippy-41+.tar.gz
# └── make.sh
#
# Usage: Use Ubuntu 18 LTS 64-bit
# 01. Log in to the home directory of the local Ubuntu system
# 02. git clone https://github.com/ophub/op.git
# 03. cd ~/op/router/phicomm_n1/flippy-kernel-build/
# 04. Put Flippy's ${build_boot}, ${build_dtb} & ${build_modules} three files into ${flippy_folder}
# 05. Run: sudo ./make.sh
# 06. The generated files path: ~/op/router/phicomm_n1/armbian/phicomm-n1/kernel/${build_save_folder}
# 07. git push to your github
# 08. Github.com Build openwrt: ~/op/.github/workflows/build-openwrt-phicomm_n1.yml
#
# Tips: If run 'sudo ./make.sh' is 'Command not found'
# 01. chmod a+x make.sh
# 02. vi make.sh
# 03. :set ff=unix
# 04. :wq


# Modify Flippy's kernel folder & version
flippy_folder="flippy"
flippy_version="5.4.63-flippy-43+o"

# Default setting ( Don't modify )
build_boot="boot-${flippy_version}.tar.gz"
build_dtb="dtb-amlogic-${flippy_version}.tar.gz"
build_modules="modules-${flippy_version}.tar.gz"
build_tmp_folder="build_tmp"
build_save_folder=${flippy_version%-flippy*}
build_Workdir=${PWD}

# build kernel.tar.xz
build_kernel() {

  echo -e " \033[1;34m【 Start build_kernel 】\033[0m ... "
  cd ${build_Workdir}
  rm -rf ${build_tmp_folder}
  mkdir -p ${build_tmp_folder}/kernel/Temp_kernel/dtb/amlogic
  mkdir -p ${build_save_folder}

  cp -rf ${flippy_folder}/${build_boot} ${build_tmp_folder}/kernel
  cp -rf ${flippy_folder}/${build_dtb} ${build_tmp_folder}/kernel

  cd ${build_tmp_folder}/kernel

     echo -e " \033[1;32m【 Start Unzip ${build_boot} 】\033[0m ... "
     if [ "${build_boot##*.}"c = "gz"c ]; then
        tar -xzf ${build_boot}
     elif [ "${build_boot##*.}"c = "xz"c ]; then
        tar -xJf ${build_boot}
     else
        echo -e " \033[1;31m【 Error build_kernel 】\033[0m ... The suffix of ${build_boot} must be tar.gz or tar.xz ... "
        exit 1
     fi

     echo -e " \033[1;32m【 Start Copy ${build_boot} five files 】\033[0m ... "
     cp -rf config-${flippy_version} Temp_kernel/
     cp -rf initrd.img-${flippy_version} Temp_kernel/
     cp -rf System.map-${flippy_version} Temp_kernel/
     cp -rf uInitrd-${flippy_version} Temp_kernel/uInitrd
     cp -rf vmlinuz-${flippy_version} Temp_kernel/zImage

     echo -e " \033[1;32m【 Start Unzip ${build_dtb} 】\033[0m ... "
     if [ "${build_dtb##*.}"c = "gz"c ]; then
        tar -xzf ${build_dtb}
     elif [ "${build_dtb##*.}"c = "xz"c ]; then
        tar -xJf ${build_dtb}
     else
        echo -e " \033[1;31m【 Error build_kernel 】\033[0m ... The suffix of ${build_dtb} must be tar.gz or tar.xz  ... "
        exit 1
     fi

     echo -e " \033[1;32m【 Start Copy ${build_dtb} one files 】\033[0m ... "
     cp -rf meson-gxl-s905d-phicomm-n1.dtb Temp_kernel/dtb/amlogic/

  cd Temp_kernel
     echo -e " \033[1;32m【 Start zip kernel.tar.xz 】\033[0m ... "
     tar -cf kernel.tar *
     xz -z kernel.tar
     rm -rf ${build_Workdir}/${build_save_folder}/kernel.tar.xz
     cp -rf kernel.tar.xz ${build_Workdir}/${build_save_folder}/kernel.tar.xz

  cd ${build_Workdir} && rm -rf ${build_tmp_folder}
  echo -e " \033[1;34m【 End build kernel.tar.xz】\033[0m The save path is /${build_save_folder}/kernel.tar.xz  ... "

}

# build modules.tar.xz
build_modules() {

  echo -e " \033[1;34m【 Start build_modules 】\033[0m ... "
  cd ${build_Workdir}
  rm -rf ${build_tmp_folder}
  mkdir -p ${build_tmp_folder}/modules/lib/modules
  mkdir -p ${build_save_folder}

  cp -rf ${flippy_folder}/${build_modules} ${build_tmp_folder}/modules/lib/modules

  cd ${build_tmp_folder}/modules/lib/modules

     echo -e " \033[1;32m【 Start Unzip ${build_modules} 】\033[0m ... "
     if [ "${build_modules##*.}"c = "gz"c ]; then
        tar -xzf ${build_modules}
     elif [ "${build_modules##*.}"c = "xz"c ]; then
        tar -xJf ${build_modules}
     else
        echo -e " \033[1;31m【 Error build_modules 】\033[0m ... The suffix of ${build_modules} must be tar.gz or tar.xz  ... "
        exit 1
     fi
  cd ${flippy_version}
     i=0
     for file in $(tree -i -f); do
         if [ "${file##*.}"c = "ko"c ]; then
             ln -s $file .
             i=$(($i+1))
         fi
     done
     echo -e " \033[1;32m【 Have [ $i ] files make ko link 】\033[0m ... "

  cd ../ && rm -rf ${build_modules} && cd ../../
     echo -e " \033[1;32m【 Start zip modules.tar.xz 】\033[0m ... "
     tar -cf modules.tar *
     xz -z modules.tar
     rm -rf ${build_Workdir}/${build_save_folder}/modules.tar.xz
     cp -rf modules.tar.xz ${build_Workdir}/${build_save_folder}/modules.tar.xz

  cd ${build_Workdir} && rm -rf ${build_tmp_folder}
  echo -e " \033[1;34m【 End build modules.tar.xz 】\033[0m The save path is /${build_save_folder}/modules.tar.xz ... "

}

# copy kernel.tar.xz & modules.tar.xz to ~/op/router/phicomm_n1/armbian/phicomm-n1/kernel/${build_save_folder}
copy_kernel_modules() {

  echo -e " \033[1;34m【 Copy /${build_save_folder}/kernel.tar.xz & modules.tar.xz to ../armbian/phicomm-n1/kernel/】\033[0m  ... "
  cd ${build_Workdir}
  cp -rf ${build_save_folder} ../armbian/phicomm-n1/kernel/
  rm -rf ${flippy_folder}/* ${build_save_folder}
  echo -e " \033[1;33m【 Delete /${flippy_folder}/* & /${build_save_folder}】\033[0m  ... "

}

# Check files
if  (test ! -f ${flippy_folder}/${build_boot} || test ! -f ${flippy_folder}/${build_dtb} || test ! -f ${flippy_folder}/${build_modules}); then
  echo -e " \033[1;31m【 Error: Files does not exist 】\033[0m \n \
  Please check if the following three files exist: \n \
  01. ${flippy_folder}/${build_boot} \n \
  02. ${flippy_folder}/${build_dtb} \n \
  03. ${flippy_folder}/${build_modules} "
  exit 1
else
  # begin run the script
  echo -e " \033[1;35m【 Start building ${build_save_folder} 】\033[0m : kernel.tar.xz & modules.tar.xz  ... "
fi

build_kernel
build_modules
copy_kernel_modules

echo -e " \033[1;35m【 Build completed ${build_save_folder} 】\033[0m : kernel.tar.xz & modules.tar.xz ... "
# end run the script

