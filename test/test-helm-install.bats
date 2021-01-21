#! /usr/bin/env bats

: ${TEST_SCRIPT:="./bin/helm-install.sh"}

# shared variables
export RELEASE="test"
export CHART="./chart/test"
export NAMESPACE="test-ns"
export SHOW_CMD="true"

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
    export VALUES="cred.user=\${REPO_USERNAME},cred.pwd=\${REPO_PASSWORD}"
    export EXPAND_CRED_VALUES="true"
    export REPO_USERNAME='testuser'
    export REPO_PASSWORD='testpwd'
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

@test "Version provided" {
    export VALUES="name=myname"
    export REPOSITORY="https://myrepo"
    export VERSION="0.0.1"
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --set name=myname --repo https://myrepo --version 0.0.1 --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}

@test "Provide repository credentials" {
    export VALUES="name=myname"
    export REPOSITORY="https://myrepo"
    export PROVIDE_REPO_CRED="true"
    export REPO_USERNAME='testuser'
    export REPO_PASSWORD='testpwd'
    run ${TEST_SCRIPT}
    grep -q 'exec helm upgrade --install --wait --set name=myname --repo https://myrepo --username testuser --password testpwd --namespace test-ns test ./chart/test' <<<"${output}"
    checkFlagsParsing "${lines[$((${#lines[*]} - 1))]}"
}
