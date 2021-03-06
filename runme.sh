#!/bin/bash

_c_magneta="\e[95m"
_c_green="\e[32m"
_c_red="\e[31m"
_c_blue="\e[34m"
RST="\e[0m"

die()    { echo -e "${_c_red}[E] ${*}${RST}";exit 1;:;}
warn()   { echo -e "${_c_red}[W] ${*}${RST}";:;}
shout()  { echo -e "${_c_blue}[-] ${*}${RST}";:;}
lshout() { echo -e "${_c_blue}-> ${*}${RST}";:;}
msg()    { echo -e "${*} \e[0m" >&2;:;}
success() { echo -e "${_c_green}${*} \e[0m" >&2;:;}

shout "Setting adb for termux.."
# arch translator
case $(uname -m) in
    arm64|aarch64)
    dir="arm64-v8a";;
    armhf|armv7l|armv8l)
    dir="armeabi-v7a";;
    i386|i868|x86)
    dir="x86";;
    amd64|x86_64)
    dir="x84_64"
    ;;
esac
cp -rv binary/"$dir"/bin/* /data/data/com.termux/files/usr/bin
success "Done.."

shout "start fix script"
bash sig9-fix.sh

