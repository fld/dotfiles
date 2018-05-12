#!/bin/bash
results=".storagebench.log"

if (( EUID == 0 )); then echo 'Do not run as root'; exit 1; fi
if ! touch "$results"; then echo 'Need write permission'; exit 1; fi
if ! sudo bash -c '(( EUID == 0 ))'; then echo 'Need sudo permissions'; exit 1; fi
if ! sudo bash -c 'hash fio ioping bonnie++' 2>/dev/null; then
    echo 'Run: sudo apt-get install fio ioping bonnie++ dmidecode gawk'
    exit 1
fi

cpunr="$(nproc)"
size="$(free --si -g | awk '/Mem:/{print 2*$2+1}')"
sysname="$(sudo dmidecode -t2 | grep Name | sed 's/\tProduct Name: //')"

mkdir bonnie || exit 1
echo -e "\n$(date) - $(uname -r) - ${size}G - $sysname: ($*)" >> "$results"

"time" iozone -i 0 -i 1 -i 2 -a -s "$size"G -r 1M 2>&1 | tee -a "$results"
sudo "time" bonnie++ -u "$USER" -s "$size"G -d bonnie/ 2>&1 | tee -a "$results"
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=128 --numjobs="$cpunr" --size=$(( size / 2 ))G --direct=1 --directory=bonnie/ --name=read-write --rw=rw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=1 --numjobs=1 --size=128M --direct=1 --directory=bonnie/ --name=randrw --rw=randrw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"
ioping -R bonnie/ | tee -a "$results"

rm -R fio.log bonnie/
