#!/bin/bash

#=============================================================================================================
# https://github.com/ophub/op
# Description: Automatically Build OpenWrt firmware for Phicomm N1
# Function: Use Flippy's OpenWrt firmware for Phicomm N1 to build kernel.tar.xz & modules.tar.xz
# Copyright (C) 2020 Flippy's OpenWrt firmware for Phicomm N1
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
flippy_file="N1_Openwrt_R20.9.15_k5.4.69-flippy-45+o.img"

# Default setting ( Don't modify )
build_Workdir=${PWD}
build_tmp_folder="tmp"
boot_tmp=${build_tmp_folder}/boot
root_tmp=${build_tmp_folder}/root
kernel_tmp=${build_tmp_folder}/kernel_tmp
modules_tmp=${build_tmp_folder}/modules_tmp/lib
rm -rf ${build_tmp_folder}

get_tree_status=$(dpkg --get-selections | grep tree)
[ $? = 0 ] || sudo apt install tree

# echo color codes
echo_color() {

    this_color=${1}
        case "${this_color}" in
        red)
            echo -e " \033[1;31m[ ${2} ]\033[0m ${3}"
            ;;
        green)
            echo -e " \033[1;32m[ ${2} ]\033[0m ${3}"
            ;;
        yellow)
            echo -e " \033[1;33m[ ${2} ]\033[0m ${3}"
            ;;
        blue)
            echo -e " \033[1;34m[ ${2} ]\033[0m ${3}"
            ;;
        purple)
            echo -e " \033[1;35m[ ${2} ]\033[0m ${3}"
            ;;
        *)
            echo -e " \033[1;30m[ ${2} ]\033[0m ${3}"
            ;;
        esac

}

# Check files
check_build_files() {

  cd ${build_Workdir}
      if  [  ! -f ${flippy_folder}/${flippy_file} ]; then
        echo_color "red" "Error: Files does not exist"  "\n \
        Please check if the following three files exist: \n \
        ${flippy_folder}/${flippy_file} "
        exit 1
      else
        # begin run the script
        echo_color "purple" "Start building"  "Use ${flippy_file} build kernel.tar.xz & modules.tar.xz ..."
        echo_color "green" "(1/7) End check_build_files"  "..."
      fi

}

#losetup & mount ${flippy_file} boot:kernel.tar.xz root:modules.tar.xz
losetup_mount_img() {

  cd ${build_Workdir}
     mkdir -p ${boot_tmp} ${root_tmp} ${kernel_tmp} ${modules_tmp}

     lodev=$(losetup -P -f --show ${flippy_folder}/${flippy_file})
     [ $? = 0 ] || ( echo "losetup ${flippy_file} failed!" && exit 1 )
     mount ${lodev}p1 ${boot_tmp}
     [ $? = 0 ] || ( echo "mount ${lodev}p1 failed!" && exit 1 )
     mount ${lodev}p2 ${root_tmp}
     [ $? = 0 ] || ( echo "mount ${lodev}p2 failed!" && exit 1 )

   echo_color "green" "(2/7) End losetup_mount_img"  "Use: ${lodev} ..."

}

#copy ${boot_tmp} & ${root_tmp} Related files to ${kernel_tmp} & ${modules_tmp}
copy_boot_root() {

  cd ${build_Workdir}

     cp -rf ${boot_tmp}/{dtb,config*,initrd.img*,System.map*,uInitrd,zImage} ${kernel_tmp}
     cp -rf ${root_tmp}/lib/modules ${modules_tmp}
     sync

  echo_color "green" "(3/7) End copy_kernel_modules"  "..."

}

#get version
get_flippy_version() {

  cd ${build_Workdir}/${modules_tmp}/modules
     flippy_version=$(ls .)
     build_save_folder=$(echo ${flippy_version} | grep -oE '^[1-9].[0-9]{1,2}.[0-9]+')
     mkdir -p ${build_Workdir}/${build_save_folder}

   echo_color "green" "(4/7) End get_flippy_version"  "${build_save_folder} ..."

}

# build kernel.tar.xz & modules.tar.xz
build_kernel_modules() {

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
        echo_color "red" "Error *.KO Files not found"  "..."
        exit 1
     else
        echo_color "yellow" "Have [ ${x} ] files make ko link"  "..."
     fi

  cd ../../../
     tar -cf modules.tar *
     xz -z modules.tar
     mv -f modules.tar.xz ${build_Workdir}/${build_save_folder}
     sync

   echo_color "green" "(5/7) End build_kernel_modules"  "..."

}

# copy kernel.tar.xz & modules.tar.xz to ~/op/router/phicomm_n1/armbian/phicomm-n1/kernel/${build_save_folder}
copy_kernel_modules() {


  cd ${build_Workdir}
     cp -rf ${build_save_folder} ../armbian/phicomm-n1/kernel/ && sync
     rm -rf ${build_save_folder}

  echo_color "green" "(6/7) End copy_kernel_modules"  "Copy /${build_save_folder}/kernel.tar.xz & modules.tar.xz to ../armbian/phicomm-n1/kernel/ ..."

}

#umount& del losetup
umount_ulosetup() {

  cd ${build_Workdir}

     umount -f ${build_Workdir}/${boot_tmp} 2>/dev/null
     umount -f ${build_Workdir}/${root_tmp} 2>/dev/null
     losetup -d ${lodev} 2>/dev/null

     rm -rf ${build_tmp_folder}
     rm -rf ${flippy_folder}/*

  echo_color "green" "(7/7) End umount_ulosetup"  "..."

}

check_build_files
losetup_mount_img
copy_boot_root
get_flippy_version
build_kernel_modules
copy_kernel_modules
umount_ulosetup

echo_color "purple" "Build completed"  "${build_save_folder}: kernel.tar.xz & modules.tar.xz  ..."

# end run the script

