#! /usr/bin/env bats

: ${TEST_SCRIPT:="./bin/helm/helm-entrypoint.sh"}

# shared variables
export RELEASE="test"
export CHART="./chart/test"
export NAMESPACE="test-ns"

# checks Helm output for non parsing errors
checkFlagsParsing() {
    if grep -q 'Error: Kubernetes cluster unreachable' <<<"${1}" \
    || grep -q "Error: path \"${CHART}\" not found" <<<"${1}"; then
        return 0
    fi
    return 1
}

@test "Nominal" {
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}

@test "Values provided" {
    export VALUES="image.repository=myrepo,image.tag=mytag"
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --set image.repository=myrepo,image.tag=mytag --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}

@test "Expand credential values" {
    export VALUES="cred.user=\${DML_USERNAME},cred.pwd=\${DML_PASSWORD}"
    export EXPAND_CRED_VALUES="true"
    export DML_USERNAME='testuser'
    export DML_PASSWORD='testpwd'
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --set cred.user=testuser,cred.pwd=testpwd --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}

@test "Repository provided" {
    export VALUES="name=myname"
    export REPOSITORY="https://myrepo"
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --set name=myname --repo https://myrepo --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}

@test "Provide repository credentials" {
    export VALUES="name=myname"
    export REPOSITORY="https://myrepo"
    export PROVIDE_REPO_CRED="true"
    export DML_USERNAME='testuser'
    export DML_PASSWORD='testpwd'
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --set name=myname --repo https://myrepo --username testuser --password testpwd --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}
