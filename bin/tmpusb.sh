#!/bin/bash
[ "$EUID" -ne 0 ] && { echo "Please run as root"; exit 1; }

tu_key="/root/.tmpusb/$(hostname)_root.key" # LUKS keyfile location

tu_uuid="6F64-654D" # TmpUsb Partition UUID
tu_dev="/dev/disk/by-uuid/$tu_uuid"
tu_unarmed="/dev/disk/by-label/Not\\x20Armed"

# Find unarmed TmpUsb and arm it with a keyfile
if [[ -b $tu_dev ]]; then
    [[ ! -e $tu_key ]] && { echo "TmpUsb: keyfile not found!"; exit 1; }
    if [[ -b $tu_unarmed && $(readlink "$tu_dev") == $(readlink "$tu_unarmed") ]]; then
        echo 'TmpUsb: Found Unarmed TmpUsb. Copying key & Arming...'
        mkdir /root/.tmpusb/mnt || exit 1
        chmod -R 700 /root/.tmpusb || exit 1
        mount -o uid=0,gid=0,fmask=0177,dmask=0177 "$tu_dev" /root/.tmpusb/mnt || exit 1
        cp "$tu_key" /root/.tmpusb/mnt/ || exit 1
        fatlabel "$tu_dev" Armed 2>/dev/null || exit 1
        diff -q "$tu_key" "/root/.tmpusb/mnt/$(basename "$tu_key")" &&
            echo 'TmpUsb: Armed.'
        umount /root/.tmpusb/mnt
        rm -dI /root/.tmpusb/mnt
    fi
else
    echo "TmpUsb not found!"
    exit 1
fi
