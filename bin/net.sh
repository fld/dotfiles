#!/bin/bash
[[ -z $1 ]] && { echo "Usage: $0 [interface]"; exit 1; }
while true; do 
    r1=$(</sys/class/net/"$1"/statistics/rx_bytes)
    t1=$(</sys/class/net/"$1"/statistics/tx_bytes)
    sleep 1s
    r2=$(</sys/class/net/"$1"/statistics/rx_bytes)
    t2=$(</sys/class/net/"$1"/statistics/tx_bytes)
    tbps=$((t2 - t1)); rbps=$((r2 - r1))
    (( tbps >= 1024000 )) && 
        u="$(<<< "scale=1; $tbps / 1024 / 1000" bc)MB/s";
    ((     tbps <= 1024000 )) && 
        u="$(<<< "scale=0; $tbps / 1024" bc)kB/s"
    (( rbps >= 1024000 )) && 
        d="$(<<< "scale=1; $rbps / 1024 / 1000" bc)MB/s"
    (( rbps <= 1024000 )) && 
        d="$(<<< "scale=0; $rbps / 1024" bc)kB/s"
    echo -e "\u2193$d \u2191$u"
    sleep 1s
done
