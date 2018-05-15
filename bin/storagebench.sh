#!/bin/bash
results=".storagebench.log"

if (( EUID == 0 )); then echo 'Do not run as root'; exit 1; fi
if ! touch "$results"; then echo 'Need write permission'; exit 1; fi
if ! sudo bash -c '(( EUID == 0 ))'; then echo 'Need sudo permissions'; exit 1; fi
if ! sudo bash -c 'hash fio ioping bonnie++ sed awk dmidecode' 2>/dev/null; then
    echo 'Run: sudo apt-get install fio ioping bonnie++ sed gawk dmidecode'
    exit 1
fi

cpunr="$(nproc)"
size="$(free --si -g | awk '/Mem:/{print 2*$2+1}')"
sysname="$(sudo dmidecode -t2 | grep Name | sed 's/\tProduct Name: //')"

mkdir bonnie fio ioping || exit 1
echo -e "\n$(date) - $(uname -r) - ${size}G - $sysname: ($*)" >> "$results"

"time" iozone -i 0 -i 1 -i 2 -a -s "$size"G -r 1M 2>&1 | tee "iozone.log"
grep -B4 "iozone test complete." iozone.log >> "$results"
sudo "time" bonnie++ -u "$USER" -s "$size"G -d bonnie/ 2>&1 | tee "bonnie.log"
grep -v "...done" bonnie.log >> "$results"
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=128 --numjobs="$cpunr" --size=$(( size / 2 ))G --direct=1 --directory=fio/ --name=read-write --rw=rw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=1 --numjobs=1 --size="$size"G --runtime=60 --direct=1 --directory=fio/ --name=randrw --rw=randrw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"
ioping -R ioping/ | tee -a "$results"

rm -R iozone.log bonnie.log fio.log bonnie/ fio/ ioping/
