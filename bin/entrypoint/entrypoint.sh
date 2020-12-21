#!/usr/bin/env bash
set -euo pipefail

# This is an helper script that allows to install pre-requisites on openshift
# a valid example could be namespace creation

# PREREQUISITE_FOLDER -> path of the folder where pre-requisites are located, if any
echo "Running /usr/local/bin/prerequisites.sh ..."
/usr/local/bin/prerequisites.sh
echo "Running /usr/local/bin/helm-entrypoint.sh"
/usr/local/bin/helm-entrypoint.sh