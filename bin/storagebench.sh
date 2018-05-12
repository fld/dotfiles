#!/bin/bash
results="~/.storagebench.log"

(( EUID == 0 )) && echo 'Do not run as root'
if ! sudo bash -c '(( EUID == 0 ))'; then
    echo 'Need sudo permissions'
fi
if ! sudo bash -c 'hash fio ioping bonnie++' 2>/dev/null; then
    echo 'Run: sudo apt-get install fio ioping bonnie++'
fi

size="$(free --si -g | awk '/Mem:/{print 2*$2+1}')"
touch "$results" || exit 1
echo -e "\n$(date) ($*)" >> "$results"
"time" iozone -i 0 -i 1 -i 2 -a -s "$size"G -r 1M 2>&1 | tee -a "$results"
mkdir bonnie
sudo "time" bonnie++ -u "$USER" -s "$size"G -d bonnie/ 2>&1 | tee -a "$results"
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=128 --numjobs=4 --size=$(( size / 2 ))G --direct=1 --directory=bonnie/ --name=read-write --rw=rw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' | tee -a "$results"
ioping -R bonnie/
rm -R fio.log bonnie/read-write.* bonnie
