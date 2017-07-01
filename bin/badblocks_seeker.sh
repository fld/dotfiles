#!/bin/bash

if [[ $# != 1 ]]; then
    echo "Usage: $0 <device>"
    echo 'Makes random 512B/512K/1M reads on device'
    exit 1
fi

dev_sz=$(sudo blockdev --getsz "$1")
while true; do 
    [[ $(shuf -i 0-1 -n1) == 0 ]] && 
        sudo dd if=/dev/sdd of=/dev/null bs=512k count=1 skip=$(shuf -i "0-$((dev_sz/1024))" -n1)
    [[ $(shuf -i 0-1 -n1) == 0 ]] && 
        sudo dd if=/dev/sdd of=/dev/null bs=512 count=1 skip=$(shuf -i "0-$dev_sz" -n1)
    [[ $(shuf -i 0-1 -n1) == 0 ]] && 
        sudo dd if=/dev/sdd of=/dev/null bs=1M count=1 skip=$(shuf -i "0-$((dev_sz/1024/2))" -n1)
    [[ $(shuf -i 0-1 -n1) == 0 ]] && 
        sleep 1s; 
done
