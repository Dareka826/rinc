#!/bin/sh
set -eu

redo-ifchange ../env ../config.sh
. ../env
. ../config.sh

for c in ../src/*.c; do
    c="./${c#../src/}"
    redo-ifchange "${c%.c}.o"
done

"${CC}" \
    ${CFLAGS} \
    ${LDFLAGS} \
    ./*.o \
    -o "${3}"

read DEPS <"./${2}.d"
redo-ifchange ${DEPS#*:}
