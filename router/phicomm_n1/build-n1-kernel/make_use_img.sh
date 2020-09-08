#!/bin/bash

#=============================================================================================================
# https://github.com/ophub/op
# Description: Automatically Build OpenWrt for Phicomm N1
# Function: Use Flippy's Phicomm N1 Openwrt firmware E.g: N1_Openwrt_R20.8.27_k5.4.63-flippy-43+o.img file build N1 kernel.tar.xz & modules.tar.xz
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/ophub/op
#=============================================================================================================
#
# example: ~/op/router/phicomm_n1/build-n1-kernel/
# ├── flippy
# │   └── N1_Openwrt_R20.8.27_k5.4.63-flippy-43+o.img
# └── make_use_img.sh
#
# Usage: Use Ubuntu 18 LTS 64-bit
# 01. Log in to the home directory of the local Ubuntu system
# 02. git clone https://github.com/ophub/op.git
# 03. cd ~/op/router/phicomm_n1/build-n1-kernel/
# 04. Put Flippy's ${flippy_file} file into ${flippy_folder}
# 05. Run: sudo ./make_use_img.sh
# 06. The generated files path: ~/op/router/phicomm_n1/armbian/phicomm-n1/kernel/${build_save_folder}
# 07. git push to your github
# 08. Github.com Build openwrt: ~/op/.github/workflows/build-openwrt-phicomm_n1.yml
#
# Tips: If run 'sudo ./make_use_img.sh' is 'Command not found'
# 01. chmod +x make_use_img.sh
# 02. vi make_use_img.sh
# 03. :set ff=unix
# 04. :wq
#
#=============================================================================================================

# Modify Flippy's kernel folder & *.img file name
flippy_folder="flippy"
flippy_file="openwrt-firmware-5.4.63.img"

# Default setting ( Don't modify )
build_Workdir=${PWD}
build_tmp_folder="tmp"
boot_tmp=${build_tmp_folder}/boot
root_tmp=${build_tmp_folder}/root
kernel_tmp=${build_tmp_folder}/kernel_tmp
modules_tmp=${build_tmp_folder}/modules_tmp/lib
rm -rf ${build_tmp_folder}
sudo apt install tree

# Check files
check_build_files() {

  echo -e " \033[1;34m【 Start check_build_files 】\033[0m ... "
  cd ${build_Workdir}
  if  [  ! -f ${flippy_folder}/${flippy_file} ]; then
    echo -e " \033[1;31m【 Error: Files does not exist 】\033[0m \n \
    Please check if the following three files exist: ${flippy_folder}/${flippy_file} "
    exit 1
  else
    echo -e " \033[1;34m【 End check_build_files 】\033[0m ... "
    echo -e " \033[1;35m【 Start building 】\033[0m Use ${flippy_file} build kernel.tar.xz & modules.tar.xz  ... "
  fi

}

#losetup & mount ${flippy_file} boot:kernel.tar.xz root:modules.tar.xz
losetup_mount_img() {

  echo -e " \033[1;34m【 Start losetup_mount_img 】\033[0m ... "
  cd ${build_Workdir}
  mkdir -p ${boot_tmp} ${root_tmp} ${kernel_tmp} ${modules_tmp}

  lodev=$(losetup -P -f --show ${flippy_folder}/${flippy_file})
  [ $? = 0 ] || die "losetup ${flippy_file} failed!"
  mount ${lodev}p1 ${boot_tmp}
  [ $? = 0 ] || die "mount ${lodev}p1 failed!"
  mount ${lodev}p2 ${root_tmp}
  [ $? = 0 ] || die "mount ${lodev}p2 failed!"

  echo -e " \033[1;34m【 End losetup_mount_img 】\033[0m ... Use: ${lodev} "

}

#copy ${boot_tmp} & ${root_tmp} Related files to ${kernel_tmp} & ${modules_tmp}
copy_boot_root() {

  echo -e " \033[1;34m【 Start copy_kernel_modules 】\033[0m ... "
  cd ${build_Workdir}

  cp -rf ${boot_tmp}/{dtb,config*,initrd.img*,System.map*,uInitrd,zImage} ${kernel_tmp}
  cp -rf ${root_tmp}/lib/modules ${modules_tmp}

  echo -e " \033[1;34m【 End copy_kernel_modules 】\033[0m ... "

}

#get version
get_flippy_version() {

  echo -e " \033[1;34m【 Start get_flippy_version 】\033[0m ... "

  cd ${build_Workdir}/${modules_tmp}/modules
  flippy_version=$(ls .)
  build_save_folder=$(echo ${flippy_version} | grep -oE '^[1-9].[0-9]{1,2}.[0-9]+')
  mkdir -p ${build_Workdir}/${build_save_folder}

  echo -e " \033[1;34m【 End get_flippy_version 】\033[0m ${build_save_folder} ... "

}

# build kernel.tar.xz & modules.tar.xz
build_kernel_modules() {

  echo -e " \033[1;34m【 Start build_kernel_modules 】\033[0m ... "

  cd ${build_Workdir}/${kernel_tmp}
  tar -cf kernel.tar *
  xz -z kernel.tar
  mv -f kernel.tar.xz ${build_Workdir}/${build_save_folder}

  cd ${build_Workdir}/${modules_tmp}/modules/${flippy_version}/

     rm -f *.ko
     x=0
     for file in $(tree -i -f); do
         if [ "${file##*.}"c = "ko"c ]; then
             ln -s $file .
             x=$(($x+1))
         fi
     done
     if [ $x -eq 0 ]; then
        echo -e " \033[1;31m【 Error *.KO Files not found 】\033[0m ... "
        exit 1
     else
        echo -e " \033[1;32m【 Have [ ${x} ] files make ko link 】\033[0m ... "
     fi

  cd ../../../
  tar -cf modules.tar *
  xz -z modules.tar
  mv -f modules.tar.xz ${build_Workdir}/${build_save_folder}

  echo -e " \033[1;34m【 End build_kernel_modules 】\033[0m ... "

}

# copy kernel.tar.xz & modules.tar.xz to ~/op/router/phicomm_n1/armbian/phicomm-n1/kernel/${build_save_folder}
copy_kernel_modules() {

  echo -e " \033[1;34m【 Start copy_kernel_modules 】\033[0m Copy /${build_save_folder}/kernel.tar.xz & modules.tar.xz to ../armbian/phicomm-n1/kernel/ ... "
  cd ${build_Workdir}
  cp -rf ${build_save_folder} ../armbian/phicomm-n1/kernel/
  rm -rf ${build_save_folder}
  echo -e " \033[1;33m【 Delete /${build_save_folder}】\033[0m  ... "
  echo -e " \033[1;34m【 End copy_kernel_modules 】\033[0m Copy complete ... "

}

#umount& del losetup
umount_ulosetup() {

  cd ${build_Workdir}
  echo -e " \033[1;34m【 Start umount_ulosetup 】\033[0m ... "

  umount ${build_Workdir}/${boot_tmp}
  umount ${build_Workdir}/${root_tmp}
  losetup -d ${lodev}

  rm -rf ${build_tmp_folder}
  rm -rf ${flippy_folder}/*

  echo -e " \033[1;34m【 End umount_ulosetup 】\033[0m ... "

}

check_build_files
losetup_mount_img
copy_boot_root
get_flippy_version
build_kernel_modules
copy_kernel_modules
umount_ulosetup

echo -e " \033[1;35m【 Build completed 】\033[0m Use ${flippy_file} build ${build_save_folder} kernel.tar.xz & modules.tar.xz  ... "

