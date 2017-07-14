#!/bin/bash

symbols='default'
[[ $(hostname) == 'main' ]] &&
    symbols='powerline'

[[ $symbols == 'powerline' && $1 == 'r' ]] &&
    echo -n ""
[[ $symbols == 'powerline' && $1 == 'rr' ]] &&
    echo -n ""
[[ $symbols == 'powerline' && $1 == 'l' ]] &&
    echo -n ""
[[ $symbols == 'powerline' && $1 == 'll' ]] &&
    echo -n ""
[[ $symbols == 'default' && $1 == 'r' ]] &&
    echo -n "◀"
[[ $symbols == 'default' && $1 == 'rr' ]] &&
    echo -n "❮"
[[ $symbols == 'default' && $1 == 'l' ]] &&
    echo -n "▶"
[[ $symbols == 'default' && $1 == 'll' ]] &&
    echo -n "❯"