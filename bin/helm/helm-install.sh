#!/usr/bin/env bash
set -euo pipefail

# get and install helm
curl -fsSL https://get.helm.sh/helm-v$HELMVERSION-linux-amd64.tar.gz | tar xz
cp linux-amd64/helm /usr/local/bin