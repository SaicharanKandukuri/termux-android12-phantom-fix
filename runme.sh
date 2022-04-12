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
cp -rv binary/"$(uname-m)"/bin/* /data/data/com.termux/files/usr/bin
success "Done.."

shout "Staring adb connect sequence.."
bash initadb.sh

shout "applying phantom fix on startup to termux.."
bash chillup-phantom-onstartup.sh
shout "Done.."
