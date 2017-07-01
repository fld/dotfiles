#!/bin/bash
stty_orig="$(stty -g)"
umask 077

pwdfile='/dev/shm/.encfs_pwd'
blank='false'
wait='20'
pass=''
i=0

failed() {
	echo -e "\nFailed! Deleting passphrase."
	rm -f "$pwdfile"
	stty "$stty_orig"
	exit 1
}

trap 'failed' SIGINT SIGTERM

echo "Enter EncFS Passphrase:" 

# Main loop executed once for each char typed...
while [[ "$blank" != "true" ]]; do
   stty -icanon -echo
   c=$(dd bs=6 count=1 2> /dev/null)

   # Check for a CR.
   if [ -z "$(printf -- "$c" | tr -d "\r\n")" ]; then
      blank='true'
   else
      stty echo
      echo -n "*"
      pass="$pass$c"
      stty -echo
   fi
done

echo -n "$pass" > $pwdfile

stty "$stty_orig"

if [[ $1 = '-d' ]]; then
	( sleep ${wait}s; rm -f "$pwdfile" ) &
	echo
	exit 0
fi

echo -e "\nYou have $wait seconds to access the container..."

while [[ $i -lt $wait ]]; do
	if [[ ! -f $pwdfile ]]; then
		echo -e "\nSuccess: Passphrase consumed."
		exit 0
	fi
		
	sleep 1s
	i=$[$i+1]
done

failed
