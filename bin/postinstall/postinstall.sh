#!/usr/bin/env bash
set -euo pipefail

# This is an helper script that allows to apply shell commands contained 
# into multiple text files stored in POSTINSTALL_FOLDER

# POSTINSTALL_FOLDER -> path of the folder where pre-requisites are located, if any
: ${POSTINSTALL_FOLDER=""}

if [ -n "$POSTINSTALL_FOLDER" ]; then
    pushd $POSTINSTALL_FOLDER > /dev/null
    for F in $(ls $POSTINSTALL_FOLDER | sort -n); do    
        echo "Running commands in file $F"
        $SHELL $F
    done
    popd > /dev/null
fi