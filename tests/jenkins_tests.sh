#!/bin/bash

# Include needed parts
source etc/config
source lib/utils.sh

zypper --non-interactive in --oldpackage test-package=42:0.0

# Run the tests

# list updates
CMD="pkg.list_updates"
INFO="Check if updates are available"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest \
    path={"$HOST","test-package"} type=s contains='42:0.1-'
assert_run

# info_available
CMD="pkg.info_available test-package"
INFO="Test info_available call"
describe "\${CMD}" "\${INFO}"
JSONOUT=$($SALT_CALL $CMD --out json)
echo "$JSONOUT" | bin/jsontest path={"$HOST","test-package","summary"} \
    type=s value="Test package for Salt's pkg.info_installed"
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","test-package","status"} \
    type=s matches="out-of-date \(version 42:0.0-.+ installed\)"
assert_run

# info_installed
CMD="pkg.info_installed test-package"
INFO="Check if pkg.info_installed works"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest \
    path={"$HOST","test-package","vendor"} type=s \
    value="obs://build.opensuse.org/systemsmanagement"
assert_run

# info_installed getting attribute
CMD="pkg.info_installed attr=epoch"
INFO="Check if pkg.info_installed returns an epoch by attribute"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest \
    path={"$HOST","test-package","epoch"} type=s value="42"
assert_run

# grains
CMD="grains.items"
INFO="Check if grains contains correct information"
describe "\${CMD}" "\${INFO}"
grains_data=$($SALT_CALL $CMD --out json)
echo "Check 'os_family' for 'Suse'"
echo "$grains_data" | bin/jsontest \
    path={"$HOST","os_family"} type=s value="Suse"
assert_run
echo "Check 'kernel' for 'Linux'"
echo "$grains_data" | bin/jsontest \
    path={"$HOST","kernel"} type=s value="Linux"
assert_run
echo "Check 'cpuarch' for 'x86_64'"
echo "$grains_data" | bin/jsontest \
    path={"$HOST","cpuarch"} type=s value="x86_64"
assert_run

