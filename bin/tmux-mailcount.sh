#!/bin/bash

# KDE Plasma-desktop 4 - Kmail Unread messages via dbus
mailcount="$(qdbus --literal org.kde.StatusNotifierItem-$(pidof kmail)-1 /StatusNotifierItem ToolTip | sed -n 's/.*"\([0-9]*\) unread message.*/\1/p')"

# Fallback to local mailbox via mailx
if [[ $? != 0 ]]; then
    mailxoutput="$(mailx &)"
    mailcount="$(echo $mailxouput | grep -o 'messages.*unread' | cut -f2 -d" ")"
fi

if [[ ! -z $mailcount ]]; then
    echo '#[fg=colour233, bg=colour148] ◚ '"$mailcount"' '
else
    echo ''
fi
