#! /usr/bin/env bats

: ${TEST_SCRIPT:="/usr/local/bin/postinstall.sh"}

MOCKED_OUTPUT=$(cat <<-EOF
Running commands in file 0
0
Running commands in file 1
1
Running commands in file 2
2
Running commands in file 3
3
Running commands in file 4
4
Running commands in file 5
5
Running commands in file 6
6
Running commands in file 7
7
Running commands in file 8
8
Running commands in file 9
9
Running commands in file 10
10
EOF
)

# shared variables
export POSTINSTALL_FOLDER="/test/postinstall"

setup() {
    mkdir -p $POSTINSTALL_FOLDER
    for F in {0..10}; do
      touch $POSTINSTALL_FOLDER/$F
      echo "echo $F" >> $POSTINSTALL_FOLDER/$F
    done
}

teardown() {
    rm -rf $POSTINSTALL_FOLDER || true
}

@test "Nominal" {
    run ${TEST_SCRIPT}
    [ "$output" = "$MOCKED_OUTPUT" ]
}

@test "No directory" {
    unset  POSTINSTALL_FOLDER
    run ${TEST_SCRIPT}
    [ "$output" = "" ]
    POSTINSTALL_FOLDER="/test/postinstall"
}