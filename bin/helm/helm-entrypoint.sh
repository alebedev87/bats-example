#!/usr/bin/env bash
set -euo pipefail

# RELEASE   -> name of the helm component to be installed
# CHART     -> path of the helm chart to be processed
# NAMESPACE -> target namespace where component should be created
echo "-----------------------------------------------------------------"
echo "| Bootstrapping "${RELEASE}" component through setupjob"
echo "| Helm chart location "${CHART}""
echo "| Target Namespace "${NAMESPACE}""
echo "-----------------------------------------------------------------"
helm upgrade --install ${RELEASE} ${CHART} --namespace ${NAMESPACE} --set chartRepository="repository.adp.amadeus.net" --wait
echo "Helm Testing ..."
helm test ${RELEASE} --namespace ${NAMESPACE}