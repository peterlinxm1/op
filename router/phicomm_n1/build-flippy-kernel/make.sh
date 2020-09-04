#!/bin/bash

#==================================================================================
# https://github.com/ophub/op
# Description: Automatically Build OpenWrt for Phicomm N1
# Function: Use Flippy's [boot/dtb/modules] build [kernel/modules]
#
# example：
# ├── flippy
# │   ├── boot-5.7.15-flippy-41+.tar.gz
# │   ├── dtb-amlogic-5.7.15-flippy-41+.tar.gz
# │   └── modules-5.7.15-flippy-41+.tar.gz
# └── make.sh
#
# Usage
# 01. Put Flippy's [boot/dtb/modules] files into flippy folder
# 02. Execute instructions: [sudo ./make.sh]
# 03. The generated file path: [/$build_save_folder]. For example:/5.7.15
# 04. Github.com kernel path: [/router/phicomm_n1/armbian/phicomm-n1/kernel/]
# 05. Github.com Build openwrt: [/.github/workflows/build-openwrt-phicomm_n1.yml]
#
# If run [sudo ./make.sh] show: Command not found
# 01. chmod a+x make.sh
# 02. vi make.sh
# 03. :set ff=unix
# 04. :wq
#==================================================================================

# Modify your Flippy's [boot/dtb/modules] folder & version
N1_flippy_folder="flippy"
N1_version="5.7.15-flippy-41+"

# Default setting (Don't modify)
N1_boot="boot-$N1_version.tar.gz"
N1_dtb="dtb-amlogic-$N1_version.tar.gz"
N1_modules="modules-$N1_version.tar.gz"
build_tmp_folder="build_tmp"
build_save_folder=${N1_version%-flippy*}
build_Workdir=$PWD
find $build_Workdir -type f -name "*DS_Store" -delete

build_kernel() {

  echo -e " \033[1;34m【 Start build_kernel 】\033[0m ... N1_boot_suffix:${N1_boot##*.} & N1_dtb_suffix:${N1_dtb##*.}"
  cd $build_Workdir
  rm -rf $build_tmp_folder
  mkdir -p $build_tmp_folder/kernel/Temp_kernel/dtb/amlogic
  mkdir -p $build_save_folder

  cp -rf $N1_flippy_folder/$N1_boot $build_tmp_folder/kernel
  cp -rf $N1_flippy_folder/$N1_dtb $build_tmp_folder/kernel

  cd $build_tmp_folder/kernel

     echo -e " \033[1;32m【 Start Unzip $N1_boot 】\033[0m ... "
     if [ "${N1_boot##*.}"c = "gz"c ]; then
        tar -xzf $N1_boot
     elif [ "${N1_boot##*.}"c = "xz"c ]; then
        tar -xJf $N1_boot
     else
        echo -e " \033[1;31m【 Error [ build_kernel ], The suffix of $N1_boot must be tar.gz or tar.xz 】\033[0m ... "
     fi

     echo -e " \033[1;32m【 Start Copy $N1_boot five files 】\033[0m ... "
     cp -rf config-$N1_version Temp_kernel/
     cp -rf initrd.img-$N1_version Temp_kernel/
     cp -rf System.map-$N1_version Temp_kernel/
     cp -rf uInitrd-$N1_version Temp_kernel/uInitrd
     cp -rf vmlinuz-$N1_version Temp_kernel/zImage

     echo -e " \033[1;32m【 Start Unzip $N1_dtb 】\033[0m ... "
     if [ "${N1_dtb##*.}"c = "gz"c ]; then
        tar -xzf $N1_dtb
     elif [ "${N1_dtb##*.}"c = "xz"c ]; then
        tar -xJf $N1_dtb
     else
        echo -e " \033[1;31m【 Error [ build_kernel ], The suffix of $N1_dtb must be tar.gz or tar.xz 】\033[0m ... "
     fi

     echo -e " \033[1;32m【 Start Copy $N1_dtb one files 】\033[0m ... "
     cp -rf meson-gxl-s905d-phicomm-n1.dtb Temp_kernel/dtb/amlogic/

  cd Temp_kernel
     echo -e " \033[1;32m【 Start zip kernel.tar.xz 】\033[0m ... "
     tar -cf kernel.tar *
     xz -z kernel.tar
     rm -rf $build_Workdir/$build_save_folder/kernel.tar.xz
     cp -rf kernel.tar.xz $build_Workdir/$build_save_folder/kernel.tar.xz

  cd $build_Workdir && rm -rf $build_tmp_folder
  echo -e " \033[1;34m【 End build kernel.tar.xz】\033[0m The save path is /$build_save_folder/kernel.tar.xz  ... "

}

build_modules() {

  echo -e " \033[1;34m【 Start build_modules 】\033[0m ... N1_modules_suffix:${N1_modules##*.} "
  cd $build_Workdir
  rm -rf $build_tmp_folder
  mkdir -p $build_tmp_folder/modules/lib/modules
  mkdir -p $build_save_folder

  cp -rf $N1_flippy_folder/$N1_modules $build_tmp_folder/modules/lib/modules

  cd $build_tmp_folder/modules/lib/modules

     echo -e " \033[1;32m【 Start Unzip $N1_modules 】\033[0m ... "
     if [ "${N1_modules##*.}"c = "gz"c ]; then
        tar -xzf $N1_modules
     elif [ "${N1_modules##*.}"c = "xz"c ]; then
        tar -xJf $N1_modules
     else
        echo -e " \033[1;31m【 Error [ build_modules ], The suffix of $N1_modules must be tar.gz or tar.xz 】\033[0m ... "
     fi
  cd $N1_version
     i=0
     for file in $(tree -i -f); do
         if [ "${file##*.}"c = "ko"c ]; then
             ln -s $file .
             i=$(($i+1))
         fi
     done
     echo -e " \033[1;32m【 Have [ $i ] files make ko link 】\033[0m ... "

  cd ../ && rm -rf $N1_modules && cd ../../
     echo -e " \033[1;32m【 Start zip modules.tar.xz 】\033[0m ... "
     tar -cf modules.tar *
     xz -z modules.tar
     rm -rf $build_Workdir/$build_save_folder/modules.tar.xz
     cp -rf modules.tar.xz $build_Workdir/$build_save_folder/modules.tar.xz

  cd $build_Workdir && rm -rf $build_tmp_folder
  echo -e " \033[1;34m【 End build modules.tar.xz 】\033[0m The save path is /$build_save_folder/modules.tar.xz ... "

}

copy_kernel_modules() {

  echo -e " \033[1;34m【 Copy /$build_save_folder/kernel.tar.xz & modules.tar.xz to ../armbian/phicomm-n1/kernel/】\033[0m  ... "
  cd $build_Workdir
  cp -rf $build_save_folder ../armbian/phicomm-n1/kernel/
  rm -rf $N1_flippy_folder/* $build_save_folder
  echo -e " \033[1;33m【 Delete /$N1_flippy_folder/* & /$build_save_folder】\033[0m  ... "

}

echo -e " \033[1;35m【 Start building [ $build_save_folder ] kernel.tar.xz & modules.tar.xz 】\033[0m ... "

build_kernel
build_modules
copy_kernel_modules

echo -e " \033[1;35m【 Build completed [ $build_save_folder ] kernel.tar.xz & modules.tar.xz 】\033[0m ... "

