#!/bin/bash

# Include needed parts
source etc/config
source lib/utils.sh

# Setup
CMD="grains.get cpuarch"
INFO="Find out x86_64 architecture in grains."

# Tell what you want to do
describe "\${CMD}" "\${INFO}"

# Run the test
$SALT_CALL $CMD | grep x86_64 || false
assert_run

# OS name
CMD="grains.get os"
INFO="Verify OS name"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path=$HOST type=s contains="SUSE"
assert_run

# list all grains
CMD="grains.items"
INFO="list all grains"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json
assert_run

# OS family
CMD="grains.get os_family"
INFO="Verify OS family is Suse"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path=$HOST type=s contains="Suse"
assert_run

# OS code name (pretty name)
CMD="grains.get oscodename"
INFO="Verify OS code name (pretty name) is $PRETTY_NAME"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path=$HOST type=s contains=$PRETTY_NAME
assert_run


# OS full name
CMD="grains.get osfullname"
INFO="Verify OS full name is $NAME"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path=$HOST type=s contains=$NAME
assert_run

# OS architecture (not CPU arch!)
CMD="grains.get osarch"
INFO="Verify package architecture is $(rpm --eval %{_host_cpu})"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path=$HOST type=s contains=$(rpm --eval %{_host_cpu})
assert_run


# OS version (don't try that at home)
CMD="grains.get osrelease"
INFO="Verify OS release is $VERSION_ID"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path=$HOST type=s contains=$VERSION_ID
assert_run

# OS release info
CMD="grains.get osrelease_info"
INFO="Verify OS release"
describe "\${CMD}" "\${INFO}"
if [ "$MINOR" != "0" ]; then
    [ "2" == $($SALT_CALL $CMD --out json | grep -v $HOSTNAME | grep "$MAJOR\|$MINOR" | wc -l) ]
else
    [ "1" == $($SALT_CALL $CMD --out json | grep -v $HOSTNAME | grep "$MAJOR\|$MINOR" | wc -l) ]
fi
assert_run
