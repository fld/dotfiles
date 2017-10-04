#!/bin/bash
tu_uuid="6F64-654D"                 # TmpUsb Partition UUID
tu_key="/root/$(hostname)_root.key" # LUKS key location

tu_dev="/dev/disk/by-uuid/$tu_uuid"
tu_unarmed="/dev/disk/by-label/Not\\x20Armed"
if [[ -e $tu_key && -b $tu_dev && -b $tu_unarmed \
        && $(readlink "$tu_dev") == $(readlink "$tu_unarmed") ]]; then
    echo 'TmpUsb: Found Unarmed tmpusb. Copying key & Arming...'
    mkdir /tmp/tmpusb &&
    mount "$tu_dev" /tmp/tmpusb &&
    cp "$tu_key" /tmp/tmpusb/ &&
    fatlabel "$tu_dev" Armed 2>/dev/null &&
    [[ -e /dev/disk/by-label/Armed/"$tu_key" ]] &&
        echo 'TmpUsb: Armed.'
    umount /tmp/tmpusb/
    rm -dI /tmp/tmpusb
fi
