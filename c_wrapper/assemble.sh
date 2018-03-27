#!/bin/bash

if [ -z "$1" -o "$1" = "--help" -o "$1" = "-h" ]
then
    echo "Essayer:"
    echo "	« $0 'movq %rax,%rbx' »,"
    echo "	« $0 'movq \$5,%rax' ret »,"
    echo "	« $0 'movq %regs,%rax' »,"
    echo "	voire même « $0 'movq %regs,%regs' »"
    exit 1
fi

tmp="$(mktemp --tmpdir assemble-XXXXXXX.o)"

dump_instr() {
    instr_machouillee="$(printf '%s' "$1" | tr '%(), $+@.' 'Xll_')"
    printf '\t%s\n' "$1" | gcc -x assembler -c /dev/stdin -o "$tmp"
    res="$(objdump -d "$tmp" | tail -n 1)"
    octets="$(printf '%s' "$res" | sed -e 's/ *0:\t\(\([0-9a-f][0-9a-f] \)*\).*$/\1/' -e 's/\([0-9a-f][0-9a-f]\)/0x\1,/g' -e 's/, *$//')"
    instr_desasm="$(printf '%s' "$res" | sed -e 's/ *0:\t\(\([0-9a-f][0-9a-f] \)*\)[ \t][ \t]*\(.*\)$/\3/')"
    printf 'const unsigned char %s [] = { %s };   /* %s */\n' "$instr_machouillee" "$octets" "$instr_desasm"
}

dump_multiregs() {
    if printf '%s' "$1" | grep '%regs' > /dev/null;
    then
        for r in %rax %rcx %rdx %rbx %rsp %rbp %rsi %rdi %r8 %r9 %r10 %r11 %r12 %r13 %r14 %r15; do
            dump_multiregs "$(printf '%s' "$1" | sed "s/%regs/$r/")"
        done
    else
        dump_instr "$1"
    fi
}

for i in "$@"; do
    dump_multiregs "$i"
done

rm "$tmp"

