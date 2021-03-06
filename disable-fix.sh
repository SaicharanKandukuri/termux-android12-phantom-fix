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
msg "${_c_magneta}Enter pairing code: "
read -r authpincode

msg "${_c_magneta}Enter debug port: "
read -r debugport

# Check is the device already conected somehow
if adb devices | grep -q "$authport" | grep "device" >> /dev/null; then
    msg "Device is connected.."
else
    pair() {
    shout "Trying to pair"
    adb pair localhost:"$authport" "$authpincode" || {
            die "Connection Failed?"
        }
    }

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

    pair
    connect
    success "Pairing localhost:$authport succeed.."

fi

success "Enabled"

shout "List connected devices.."
adb devices -l
success "ADB setup complete..."

shout "disabling sig9 fix.."

# Freeze config
adb shell device_config \
    set_sync_disabled_for_tests none || {
        die "Failed to disable.. [Try executing again]"
    }
echo "✌️ Disabled"
echo "Changes may take place after a device restart.."

success "current max_phantom_processes = $(adb shell device_config get activity_manager max_phantom_processes)"
