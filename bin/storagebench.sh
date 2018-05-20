#!/bin/bash
results=".storagebench.log"

if (( EUID == 0 )); then echo 'Do not run as root'; exit 1; fi
if ! touch "$results"; then echo 'Need write permission'; exit 1; fi
if ! sudo bash -c '(( EUID == 0 ))'; then echo 'Run with sudo'; exit 1; fi
if ! sudo bash -c 'hash fio ioping bonnie++ sed awk dmidecode' 2>/dev/null; then
    sudo apt install fio ioping bonnie++ sed gawk dmidecode || exit 1
fi

if [[ -z $2 ]]; then
    echo "Usage: $(basename "$0") <comments>..[notes]..[etc] ..."
    exit 1
fi

cpunr="$(nproc)"
size="$(free --si -g | awk '/Mem:/{print 2*$2+1}')"
frspace="$(df -P -B 1G . | tail -1 | awk '{print $4}')"
sysname="$(sudo dmidecode -t2 | grep Name | sed 's/\tProduct Name: //')"
function sgb_wait() {
    sync
    sleep 10s # TODO: instead, wait for low io-wait%?
}

if (( frspace < size )); then
    echo 'Not enough free space on disk!'
    exit 1
fi

# Begin bench..
mkdir bonnie fio ioping || exit 1
echo -e "\n$(date) - $(uname -r) - ${size}G - $sysname: ($*)" | tee -a "$results"

# Bonnie++
echo -e "\n### Bonnie ###" | tee -a "$results"
sudo "time" bonnie++ -u "$USER" -s "$size"G -d bonnie/ 2>&1 | tee "bonnie.log"
grep -v -e "...done" -e "Using uid" -e "1.97,1.97" bonnie.log >> "$results"
sgb_wait

# fio
function sgb_fiolog() {
    # -e 'ios=', for per-device io stats
    grep fio.log -i -e 'write: i' -e 'read :' -e 'read:' -e 'cpu' -e 'ioen' -e 'aggrmerge=' | tee -a "$results"
    echo | tee -a "$results"
}
echo -e "\n### fio ###" | tee -a "$results"
# 4k seq. read
fio --output=fio.log --directory=fio/ --iodepth=128 --size="$size"G --name=4k-read --rw=read
sgb_fiolog
# 4k seq. write
fio --output=fio.log --directory=fio/ --iodepth=128 --size="$size"G --name=4k-write --rw=write
sgb_fiolog
sgb_wait
# 4k rand. read
fio --output=fio.log --directory=fio/ --iodepth=128 --size="$size"G --runtime=60 --name=4k-randread --rw=randread
sgb_fiolog
# 4k rand. write
fio --output=fio.log --directory=fio/ --iodepth=128 --size="$size"G --runtime=60 --fsync=1 --name=4k-randwrite --rw=randwrite
sgb_fiolog
sgb_wait

# Iozone
function sgb_iozlog() {
    grep -m1 "Command line used:" iozone.log >> "$results"
    grep -A1 -B4 "iozone test complete." iozone.log | grep -v iozone >> "$results"
}
echo -e "### Iozone ###" | tee -a "$results"
# 1G O_SYNC write test (1M block)
"time" iozone -i 0 -i 2 -i 4 -i 6 -i 9 -i 11 -a -o -s 1G -r 1M 2>&1 | tee "iozone.log"
sgb_iozlog
sgb_wait
# Full test (1M block)
"time" iozone -i 0 -i 1 -i 2 -a -s "$size"G -r 1M 2>&1 | tee "iozone.log"
sgb_iozlog
sgb_wait

# ioping
# Seek rate: read
"time" ioping -i0 -S "$size"G -w 60 -q ioping/ | tee -a "$results"
# Seek rate: write
"time" ioping -i0 -S "$size"G -w 60 -W -q ioping/ | tee -a "$results"

# Cleanup
rm -R iozone.log bonnie.log fio.log bonnie/ fio/ ioping/
