#!/bin/bash

if [ -z "$1" ]
then
    echo "Essayer $0 'movq %rax,%rbx'"
    exit 1
fi

tmp="$(mktemp --tmpdir assemble-XXXXXXX.o)"
instr="$(tr '%(), $+@.' 'Xll_' <<< "$1")"
printf '\t%s\n' "$1" | gcc -x assembler -c /dev/stdin -o "$tmp"
objdump -d "$tmp" | grep '^ *0:' | sed -e 's/ *0:\t\(\([0-9a-f][0-9a-f] \)*\)  *.*$/\1/' -e 's/\([0-9a-f][0-9a-f]\)/0x\1,/g' -e "s/^/const unsigned char $instr [] = {/" -e 's/, *$/};/'
rm "$tmp"
