#!/bin/bash
tu_uuid="6F64-654D"                 # TmpUsb Partition UUID
tu_key="/root/$(hostname)_root.key" # LUKS key location

tu_dev="/dev/disk/by-uuid/$tu_uuid"
tu_unarmed="/dev/disk/by-label/Not\\x20Armed"
if [[ -e $tu_key && -b $tu_dev && -b $tu_unarmed \
        && $(readlink "$tu_dev") == $(readlink "$tu_unarmed") ]]; then
    echo 'TmpUsb: Found Unarmed tmpusb. Copying key & Arming...'
    mkdir /tmp/tmpusb || exit 1
    mount "$tu_dev" /tmp/tmpusb || exit 1
    chmod 700 /tmp/tmpusb || exit 1
    cp "$tu_key" /tmp/tmpusb/ || exit 1
    fatlabel "$tu_dev" Armed 2>/dev/null || exit 1
    diff -q "$tu_key" "/tmp/tmpusb/$(basename "$tu_key")" &&
        echo 'TmpUsb: Armed.'
    umount /tmp/tmpusb/
    rm -dI /tmp/tmpusb
fi
