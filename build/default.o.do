#!/bin/sh
set -eu

redo-ifchange ../env ../config.sh
. ../env
. ../config.sh

"${CC}" \
    ${CFLAGS} \
    -c \
    "../src/${2}.c" \
    -o "./${3}" \
    -MD \
    -MF "./${2}.d"

read DEPS <"./${2}.d"
redo-ifchange ${DEPS#*:}
