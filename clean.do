#!/bin/sh
set -eu

redo-ifchange ./config.sh
. ./config.sh

rm -f ./build/*.o || :
rm -f ./build/*.d || :
rm -f ./build/main || :
rm -f ./"${BIN_NAME}" || :

rm -f "${3}" || :
