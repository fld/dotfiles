#!/bin/bash
results=".storagebench.log"

if (( EUID == 0 )); then echo 'Do not run as root'; exit 1; fi
if ! touch "$results"; then echo 'Need write permission'; exit 1; fi
if ! sudo bash -c '(( EUID == 0 ))'; then echo 'Need sudo permissions'; exit 1; fi
if ! sudo bash -c 'hash fio ioping bonnie++ sed awk dmidecode' 2>/dev/null; then
    sudo apt install fio ioping bonnie++ sed gawk dmidecode || exit 1
fi

cpunr="$(nproc)"
size="$(free --si -g | awk '/Mem:/{print 2*$2+1}')"
sysname="$(sudo dmidecode -t2 | grep Name | sed 's/\tProduct Name: //')"

mkdir bonnie fio ioping || exit 1
echo -e "\n$(date) - $(uname -r) - ${size}G - $sysname: ($*)" | tee -a "$results"

# Bonnie++
echo -e "\n### Bonnie ###" | tee -a "$results"
sudo "time" bonnie++ -u "$USER" -s "$size"G -d bonnie/ 2>&1 | tee "bonnie.log"
grep -v -e "...done" -e "Using uid" bonnie.log >> "$results"

# fio
echo -e "\n### fio ###" | tee -a "$results"
# O_DIRECT deep Read-write
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=128 --numjobs=1 --size=4G --direct=1 --directory=fio/ --name=read-write --rw=rw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"
echo | tee -a "$results"
# O_DIRECT deep 4k-Rand-Read-Write
fio --output=fio.log --bs=4k --ioengine=libaio --iodepth=128 --numjobs=1 --size=1G --runtime=60 --direct=1 --directory=fio/ --name=randrw --rw=randrw
grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"

# Iozone
echo -e "\n### Iozone ###" | tee -a "$results"
# O_DIRECT
"time" iozone -i 0 -i 1 -i 2 -a -I -s 1G -r 1M 2>&1 | tee "iozone.log"
grep -m1 "Command line used:" iozone.log >> "$results"
grep -B4 "iozone test complete." iozone.log | head -n3 >> "$results"
# O_DIRECT + O_SYNC
"time" iozone -i 0 -i 1 -i 2 -a -Io -s 512M -r 1M 2>&1 | tee "iozone.log"
grep -m1 "Command line used:" iozone.log >> "$results"
grep -B4 "iozone test complete." iozone.log | head -n3 >> "$results"
# Full buffered test
"time" iozone -i 0 -i 1 -i 2 -a -s "$size"G -r 1M 2>&1 | tee "iozone.log"
grep -m1 "Command line used:" iozone.log >> "$results"
grep -B4 "iozone test complete." iozone.log | head -n3 >> "$results"

# ioping
# Seek rate
ioping -R ioping/ | tee -a "$results"

# Cleanup
rm -R iozone.log bonnie.log fio.log bonnie/ fio/ ioping/
