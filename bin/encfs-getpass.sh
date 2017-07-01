#!/bin/bash
pwdfile='/dev/shm/.encfs_pwd'

if [[ -f $pwdfile ]] 
then
	cat "$pwdfile"
	[[ ! $1 == '-n' ]] && rm -f "$pwdfile"
	exit 0
fi
exit 1
