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
function sgb_fiolog() {
    grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'Run' -e 'ioen' -e 'ios=' | tee -a "$results"
    echo | tee -a "$results"
}
echo -e "\n### fio ###" | tee -a "$results"
# 4k seq. read
fio --output=fio.log --iodepth=128 --size="$size"G --directory=fio/ --name=4k-read --rw=read
sgb_fiolog
# 4k seq. write
fio --output=fio.log --iodepth=128 --size="$size"G --directory=fio/ --name=4k-write --rw=write
sgb_fiolog
# 4k rand. read
fio --output=fio.log --iodepth=128 --size="$size"G --directory=fio/ --name=4k-randread --rw=randread --runtime=60
sgb_fiolog
# 4k rand. write
fio --output=fio.log --iodepth=128 --size="$size"G --directory=fio/ --name=4k-randwrite --rw=randwrite --runtime=60
sgb_fiolog

# Iozone
function sgb_iozlog() {
    grep -m1 "Command line used:" iozone.log >> "$results"
    grep -A1 -B4 "iozone test complete." iozone.log | grep -v iozone >> "$results"
}
echo -e "\n### Iozone ###" | tee -a "$results"
# 1G O_SYNC test (1M block)
"time" iozone -a -o -s 1G -r 1M 2>&1 | tee "iozone.log"
sgb_iozlog
# Full test (1M block)
"time" iozone -a -s "$size"G -r 1M 2>&1 | tee "iozone.log"
#"time" iozone -i 0 -i 1 -i 2 -a -s "$size"G -r 1M 2>&1 | tee "iozone.log"
sgb_iozlog

# ioping
# Seek rate: read
"time" ioping -i0 -S "$size"G -w 60 -q ioping/ | tee -a "$results"
# Seek rate: write
"time" ioping -i0 -S "$size"G -w 60 -W -q ioping/ | tee -a "$results"

# Cleanup
rm -R iozone.log bonnie.log fio.log bonnie/ fio/ ioping/
