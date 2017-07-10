#!/bin/bash
while true; do
    mps=$(sar -u ALL 1 1)
    cpu=$(<<<"$mps" awk '!/Average/ && /all/ { printf("%2d", 100 - $12) }')
    usr=$(<<<"$mps" awk '!/Average/ && /all/ { printf("%-2d", $3) }')
    sys=$(<<<"$mps" awk '!/Average/ && /all/ { printf("%-2d", $5) }')
    iow=$(<<<"$mps" awk '!/Average/ && /all/ { printf("%-2d", $6) }')
    gus=$(<<<"$mps" awk '!/Average/ && /all/ { printf("%-2d", $10) }')
    echo -n "(cpu: $cpu% u:$usr% s:$sys% i:$iow% g:$gus%) "
    load="$(cut /proc/loadavg -d ' ' -f1,2,3)"
    echo -n "(load: $load)"
    echo ""
done
