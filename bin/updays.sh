#!/bin/bash
uptime=$(</proc/uptime)
uptime=${uptime%%.*}
echo $(( uptime/60/60/24 ))
