#!/bin/bash

# Include needed parts
source etc/config
source lib/utils.sh

EXITCODE=0

function version_test {
    local v1="$1"
    local v2="$2"
    local expect="$3"

    # Setup
    local CMD="pkg.version_cmp '$v1' '$v2'"
    local INFO="Compare '$v1' with '$v2' expecting '$expect'"

    # Tell what you want to do
    describe "\${CMD}" "\${INFO}"

    local RESULT=`$SALT_CALL --out text $CMD | awk -F': ' '{print $2}'`
    echo "Result: $RESULT" >&2
    test "$RESULT" = "$expect" || { echo "failed" >&2; exit 1; }
}

version_test '0.2-1' '0.2-1' '0'
version_test '0.2-1.0' '0.2-1' '1'
version_test '0.2.0-1' '0.2-1' '1'
version_test '0.2-1' '1:0.2-1' '-1'
version_test '1:0.2-1' '0.2-1' '1'

if [ ${VERSION_ID%.*} -ge 12 ]; then
    # ~ has a special meaning since SLE12
    version_test '0.2-1' '0.2~beta1-1' '1'
    version_test '0.2~beta2-1' '0.2-1' '-1'
else
    version_test '0.2-1' '0.2~beta1-1' '-1'
    version_test '0.2~beta2-1' '0.2-1' '1'
fi

