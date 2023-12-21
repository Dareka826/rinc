#!/bin/sh
set -eu

NL="$(printf "\nx")"
NL="${NL%x}"

e() {
    e_val="$(\
        eval "cat <<'xxxEOFxxx'${NL}${2}${NL}xxxEOFxxx${NL}" | \
        sed "s/'/'\\\\''/g")"
    printf "%s='%s'\n" "${1}" "${e_val}"
}

CC="${CC:-cc}"
CFLAGS="-O2 -pipe -Wall -Wextra -Wconversion -Werror -std=c99 ${CFLAGS:-}"
LDFLAGS="${LDFLAGS:-}"

truncate -s0 "${3}"
e "CC" "${CC}" >>"${3}"
e "CFLAGS" "${CFLAGS}" >>"${3}"
e "LDFLAGS" "${LDFLAGS}" >>"${3}"
