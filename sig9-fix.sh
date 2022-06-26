#!/bin/bash

_c_magneta="\e[95m"
_c_green="\e[32m"
_c_red="\e[31m"
_c_blue="\e[34m"
RST="\e[0m"

die() {
    echo -e "${_c_red}[E] ${*}${RST}"
    exit 1
    :
}
warn() {
    echo -e "${_c_red}[W] ${*}${RST}"
    :
}
shout() {
    echo -e "${_c_blue}[-] ${*}${RST}"
    :
}
lshout() {
    echo -e "${_c_blue}-> ${*}${RST}"
    :
}
msg() {
    echo -e "${*} \e[0m" >&2
    :
}
success() {
    echo -e "${_c_green}${*} \e[0m" >&2
    :
}

F=0

msg "${_c_magneta}Enter Auth port ( Port show in option enter six digit number): "
read -r authport
msg "${_c_magneta}Enter Auth pincode: "
read -r authpincode

msg "${_c_magneta}Enter debug port: "
read -r debugport

pair() {
    shout "Trying to pair"
    adb pair localhost:"$authport" "$authpincode" || {
        die "Connection Failed?"
    }
}

pair

success "Pairing localhost:$authport succeed.."

connect() {
    shout "Trying to enable adb over tcpip at 5813"
    adb connect localhost:"$debugport" || {
        warn "Failed to connect.."
        shout "Trying to pair back"
        [[ $F -gt 3 ]] && {
            die "Failed to connect.. Max retry reached"
        }
        ((F++))
        pair
        connect
    }
}

adb tcpip 5813 || {
    die "failed to start tcpip"
}

success "Enabled"

shout "List connected devices.."
adb devices -l
success "ADB setup complete..."

shout "Trying to fix phantom service ${_c_green}forever"

# Freeze config
abd device_config \
    set_sync_disabled_for_tests persistent

adb \
    shell \
    device_config \
    put activity_manager \
    max_phantom_processes 214181594 || {
    lwarn "Failed to set max_phantom_processes"
}
success "current max_phantom_processes = $(adb shell device_config get activity_manager max_phantom_processes)"
