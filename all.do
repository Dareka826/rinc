#!/bin/sh
set -eu

redo-ifchange ./env ./config.sh
. ./env
. ./config.sh

redo-ifchange ./build/main
cp ./build/main ./"${BIN_NAME}"

rm -f "${3}" || :
