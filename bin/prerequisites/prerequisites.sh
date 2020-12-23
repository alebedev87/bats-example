#!/usr/bin/env bash
set -euo pipefail

# This is an helper script that allows to install pre-requisites on openshift
# a valid example could be namespace creation

# PREREQUISITE_FOLDER -> path of the folder where pre-requisites are located, if any
: ${PREREQUISITE_FOLDER=""}

if [ -n "$PREREQUISITE_FOLDER" ]; then
    pushd $PREREQUISITE_FOLDER > /dev/null
    for F in $(ls $PREREQUISITE_FOLDER | sort -n); do
        echo "Running - exec oc apply -f $F"
        oc apply -f $F
    done
    popd > /dev/null
fi