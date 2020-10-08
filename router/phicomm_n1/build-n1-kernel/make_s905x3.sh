#!/bin/bash

#===============================================================================================================
# https://github.com/ophub/op
# Description: Use Phicomm N1 firmware to build s905x3 related firmware(n1-thresh x96-100m x96-1000m hk1)
# Function: Use Phicomm N1 firmware to build s905x3 related firmware
# Copyright (C) 2020 https://github.com/ophub/op
#===============================================================================================================
#
# example: ~/op/router/phicomm_n1/build-n1-kernel/
# ├── flippy
# │   └── phicomm.img
# └── make_s905x3.sh
#
# Usage: Use Ubuntu 18 LTS 64-bit
# 01. Log in to the home directory of the local Ubuntu system
# 02. git clone https://github.com/ophub/op.git
# 03. cd ~/op/router/phicomm_n1/build-n1-kernel/
# 04. Put Phicomm N1 firmware ${flippy_file} file into ${flippy_folder}
# 05. Run: sudo ./make_s905x3.sh
# 06. The generated files path: ~/op/router/phicomm_n1/build-n1-kernel/openwrt_${convert_firmware}.img
# 07. git push to your github
# 08. Github.com Build openwrt: ~/op/.github/workflows/build-openwrt-s905x3.yml
#
# Tips: If run 'sudo ./make_s905x3.sh' is 'Command not found'
# 01. chmod +x make_s905x3.sh
# 02. vi make_s905x3.sh
# 03. :set ff=unix
# 04. :wq
#
# Warning:❗❗❗
# According to Flippy’s introduction, the difference between s905x3 and Phicomm-N1 firmware is the difference 
# in the dtb file specified in boot/uEnv.txt, and the contents of other firmware are common. 
# This script downloads the N1 firmware that has been built, and modifies the path to the dtb file. 
# Since the s905x3 device has not been purchased, the firmware has not been personally tested, 
# and the script has just been online, there may be unknown bugs. 
# You can also test other N1 dtb paths according to the introduction.
#
# /boot/uEnv.txt: ✅ 
#    #Method: Add # in front of the dtb file path of Phicomm N1, and remove the # in front of the firmware you need. E.g
#
#    #Phicomm N1 
#    #FDT=/dtb/amlogic/meson-gxl-s905d-phicomm-n1.dtb
#    #Phicomm N1 (thresh)
#    #FDT=/dtb/amlogic/meson-gxl-s905d-phicomm-n1-thresh.dtb
#
#    #X96 Max+ (S905X3 for 100m)
#    #FDT=/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb
#    #X96 Max+ (S905X3 for 1000M)
#    #FDT=/dtb/amlogic/meson-sm1-x96-max-plus.dtb
#
#    #HK1 BoX (S905X3 for 1000M)
#    FDT=/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb
#=============================================================================================================

# Modify Phicomm N1 firmware's folder & *.img file name
flippy_folder="flippy"
flippy_file="phicomm.img"

# Default setting ( Don't modify )
#build_Workdir=${PWD}
build_Workdir="router/phicomm_n1/build-n1-kernel"
build_tmp_folder="tmp"
boot_tmp=${build_tmp_folder}/boot
root_tmp=${build_tmp_folder}/root
rm -rf ${build_tmp_folder}

firmware_list="n1-thresh x96-100m x96-1000m hk1"
convert_firmware=${1}
if  [ ! -n "${convert_firmware}" ]; then
  echo "You did not specify the parameters of the conversion firmware!"
  exit 1
fi

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
        Please check if the following one files exist: \n \
        ${flippy_folder}/${flippy_file} "
        exit 1
      else
        # begin run the script
        echo_color "purple" "Start convert"  "Use [ ${flippy_file} ] Convert to [ ${convert_firmware}] ..."
        echo_color "green" "(1/4) End check_build_files" "..."
      fi

}

#losetup & mount ${flippy_file}
losetup_mount_img() {

     mkdir -p ${boot_tmp} ${root_tmp}

     lodev=$(losetup -P -f --show ${flippy_folder}/${flippy_file})
     [ $? = 0 ] || ( echo "losetup ${flippy_file} failed!" && exit 1 )
     mount ${lodev}p1 ${boot_tmp}
     [ $? = 0 ] || ( echo "mount ${lodev}p1 failed!" && exit 1 )
     mount ${lodev}p2 ${root_tmp}
     [ $? = 0 ] || ( echo "mount ${lodev}p2 failed!" && exit 1 )

     echo_color "green" "(2/4) End losetup_mount_img" "Use: ${lodev} ..."

}

#edit uEnv.txt from ${boot_tmp}
edit_uenv() {

  cd ${boot_tmp}

        if [  ! -f "uEnv.txt" ]; then
           echo_color "red" "Error: uEnv.txt Files does not exist"  "\n \
           Please check if the following one files exist: \n \
           ${boot_tmp}/uEnv.txt \n \
           Current path -PWD-: [ ${PWD} ]
           Situation -lsblk-: [ $(lsblk) ]
           Directory file list -ls-: [ $(ls .) ]
           "

           exit 1
        fi
        
        no_firmware=false
        case "${convert_firmware}" in
        n1-thresh)
            old_phicomm_str="#FDT=\/dtb\/amlogic\/meson-gxl-s905d-phicomm-n1-thresh.dtb"
            new_phicomm_str="FDT=\/dtb\/amlogic\/meson-gxl-s905d-phicomm-n1-thresh.dtb"
            sed -i "s/${old_phicomm_str}/${new_phicomm_str}/g" uEnv.txt
            echo_color "yellow" "phicomm-n1-thresh: convert completed" "..."
            ;;
        x96-100m)
            old_x96100m_str="#FDT=\/dtb\/amlogic\/meson-sm1-x96-max-plus-100m.dtb"
            new_x96100m_str="FDT=\/dtb\/amlogic\/meson-sm1-x96-max-plus-100m.dtb"
            sed -i "s/${old_x96100m_str}/${new_x96100m_str}/g" uEnv.txt
            echo_color "yellow" "x96-max-plus-100m: convert completed" "..."
            ;;
        x96-1000m)
            old_x961000m_str="#FDT=\/dtb\/amlogic\/meson-sm1-x96-max-plus.dtb"
            new_x961000m_str="FDT=\/dtb\/amlogic\/meson-sm1-x96-max-plus.dtb"
            sed -i "s/${old_x961000m_str}/${new_x961000m_str}/g" uEnv.txt
            echo_color "yellow" "x96-max-plus-1000m: convert completed" "..."
            ;;
        hk1)
            old_hk1_str="#FDT=\/dtb\/amlogic\/meson-sm1-hk1box-vontar-x3.dtb"
            new_hk1_str="FDT=\/dtb\/amlogic\/meson-sm1-hk1box-vontar-x3.dtb"
            sed -i "s/${old_hk1_str}/${new_hk1_str}/g" uEnv.txt
            echo_color "yellow" "hk1box-vontar-x3: convert completed" "..."
            ;;
        *)
            echo_color "red" "have no this firmware: ${convert_firmware}"  "Please select from this list: [ ${firmware_list} ]"
            no_firmware=ture
            ;;
        esac

        if [ ${no_firmware} = false ]; then
            old_str="FDT=\/dtb\/amlogic\/meson-gxl-s905d-phicomm-n1.dtb"
            new_str="#FDT=\/dtb\/amlogic\/meson-gxl-s905d-phicomm-n1.dtb"
            sed -i "s/${old_str}/${new_str}/g" uEnv.txt
            echo_color "yellow" "old-phicomm-n1: have close" "..."
        fi

     sync

  echo_color "green" "(3/4) End edit_uenv"  "..."

}

#umount & del losetup
umount_ulosetup() {

  cd ../../

     echo "-----------------begin umount_ulosetup-----------------"
     umount -f ${boot_tmp} 2>/dev/null
     umount -f ${root_tmp} 2>/dev/null
     losetup -d ${lodev} 2>/dev/null
     [ $? = 0 ] || ( echo "umount ${lodev} failed!" && exit 1 )
     
     echo "Current path -PWD-: [ ${PWD} ]"
     echo "Situation -lsblk-: [ $(lsblk) ]"
     echo "Directory file list -ls-: [ $(ls .) ]"
           
     if [ ${no_firmware} = false ]; then
        cp -f ${flippy_folder}/${flippy_file} openwrt_${convert_firmware}.img
     fi

     sync

     rm -rf ${build_tmp_folder}
     rm -rf ${flippy_folder}/*

  echo_color "green" "(4/4) End umount_ulosetup"  "..."

}


check_build_files
losetup_mount_img
edit_uenv
umount_ulosetup

echo_color "purple" "convert completed"  "..."

# end run the script

