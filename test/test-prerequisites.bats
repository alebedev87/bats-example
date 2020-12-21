#! /usr/bin/env bats

: ${TEST_SCRIPT:="/usr/local/bin/prerequisites.sh"}

MOCKED_OUTPUT=$(cat <<-EOF
Running - exec oc apply -f 0
apply -f 0
Running - exec oc apply -f 1
apply -f 1
Running - exec oc apply -f 2
apply -f 2
Running - exec oc apply -f 3
apply -f 3
Running - exec oc apply -f 4
apply -f 4
Running - exec oc apply -f 5
apply -f 5
Running - exec oc apply -f 6
apply -f 6
Running - exec oc apply -f 7
apply -f 7
Running - exec oc apply -f 8
apply -f 8
Running - exec oc apply -f 9
apply -f 9
Running - exec oc apply -f 10
apply -f 10
EOF
)

# shared variables
export PREREQUISITE_FOLDER="/test/prerequisites"

setup() {
    mkdir -p $PREREQUISITE_FOLDER
    for F in {0..10}; do
      touch $PREREQUISITE_FOLDER/$F
    done
    mv /usr/local/bin/oc /usr/local/bin/oc_old && ln -s /bin/echo /bin/oc
}

teardown() {
    rm -rf $PREREQUISITE_FOLDER || true
    rm -rf /bin/oc || true
    mv /usr/local/bin/oc_old /usr/local/bin/oc
}

@test "Nominal" {
    run ${TEST_SCRIPT}
    [ "$output" = "$MOCKED_OUTPUT" ]
}

@test "No directory" {
    unset PREREQUISITE_FOLDER
    run ${TEST_SCRIPT}
    [ "$output" = "" ]
}
