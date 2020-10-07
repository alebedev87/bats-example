#!/usr/bin/env bash
set -euo pipefail

# ARGUMENTS:

# RELEASE            -> name of the helm component to be installed
# CHART              -> path of the helm chart to be processed
# NAMESPACE          -> target namespace where component should be created
# VALUES             -> values to be passed as an argument to --set option
# EXPAND_CRED_VALUES -> expand environment variables inside VALUES variable
# REPOSITORY         -> repository URL as passed to --repo option
# PROVIDE_REPO_CRED  -> use externally provided Helm repository credentials

# NOTES:

# DML_USERNAME and DML_PASSWORD are expected to be set externally
# if EXPAND_CRED_VALUES or PROVIDE_REPO_CRED is used

# optional arguments
: ${VALUES:=""}
: ${EXPAND_CRED_VALUES:="false"}
: ${REPOSITORY:=""}
: ${PROVIDE_REPO_CRED:=""}

cat - <<EOF
-----------------------------------------------------------------
| Bootstrapping "${RELEASE}" component through setupjob"
| Helm chart location "${CHART}"
| Target Namespace "${NAMESPACE}"
-----------------------------------------------------------------
EOF

# update options
OPTS=(--install --wait)

if [ -n "${VALUES}" ]; then
    if [ "${EXPAND_CRED_VALUES}" = "true" ]; then
        VALUES=$(envsubst '$DML_USERNAME$DML_PASSWORD' <<<"${VALUES}")
    fi
    OPTS+=(--set "${VALUES}")
fi

if [ -n "${REPOSITORY}" ]; then
    OPTS+=(--repo "${REPOSITORY}")
    if [ "${PROVIDE_REPO_CRED}" = "true" ]; then
        OPTS+=(--username "${DML_USERNAME}" --password "${DML_PASSWORD}")
    fi
fi

set -x
exec helm upgrade ${OPTS[@]} --namespace "${NAMESPACE}" "${RELEASE}" "${CHART}"
