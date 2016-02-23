#!/bin/bash

# Include needed parts
source etc/config
source lib/utils.sh

EXITCODE=0

CMD="pkg.owner '/etc/zypp'"
INFO="Testing pkg.owner of /etc/zypp"
# Tell what you want to do
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path="$HOST" type=s value="libzypp"
assert_run

# list products
CMD="pkg.list_products"
INFO="Testing pkg.list_products"
# Tell what you want to do
describe "\${CMD}" "\${INFO}"
JSONOUT=$($SALT_CALL $CMD --out json)
echo "$JSONOUT" | bin/jsontest path={"$HOST","name"} type=s value="SLES"
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","version"} type=s value="12.1"
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","release"} type=s value="0"
assert_run


INFO="Testing pkg.list_products with OEM release"
describe "\${CMD}" "\${INFO}"
mkdir -p /var/lib/suseRegister/OEM
echo "OEM" > /var/lib/suseRegister/OEM/sles
JSONOUT=$($SALT_CALL $CMD --out json)
echo "$JSONOUT" | bin/jsontest path={"$HOST","productline"} type=s value="sles"
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","release"} type=s value="OEM"
assert_run
rm -f /var/lib/suseRegister/OEM/sles

# repo handling

CMD="pkg.mod_repo repotest url=file:///tmp"
INFO="Create a test repo"
describe "\${CMD}" "\${INFO}"
JSONOUT=$($SALT_CALL $CMD --out json)
echo "$JSONOUT" | bin/jsontest path={"$HOST","alias"} type=s value="repotest"
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","autorefresh"} type=b value=
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","enabled"} type=b value=1
assert_run

CMD="pkg.mod_repo repotest refresh=1 enabled=0"
INFO="Modify test repo"
describe "\${CMD}" "\${INFO}"
JSONOUT=$($SALT_CALL $CMD --out json)
echo "$JSONOUT" | bin/jsontest path={"$HOST","autorefresh"} type=b value=1
assert_run
echo "$JSONOUT" | bin/jsontest path={"$HOST","enabled"} type=b value=
assert_run

CMD="pkg.del_repo repotest"
INFO="Delete test repo"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path={"$HOST","message"} \
    type=s value="Repository 'repotest' has been removed."
assert_run
if [ -e /etc/zypp/repos.d/repotest.repo ]; then
    exit 1
fi

# refresh
CMD="pkg.refresh_db"
INFO="Refreshing repositories"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path={"$HOST","testpackages"} \
    type=b value="True"
assert_run

# list patterns
CMD="pkg.list_patterns"
INFO="List Patterns"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path={"$HOST","Minimal","installed"} \
    type=b value=
assert_run

# search
CMD="pkg.search test-package"
INFO="Test search"
describe "\${CMD}" "\${INFO}"
JSONOUT=$($SALT_CALL $CMD --out json)
echo "$JSONOUT" | bin/jsontest path={"$HOST","test-package-zypper","summary"} \
    type=s value="Test package for Salt's pkg.latest"
assert_run

# download
CMD="pkg.download test-package"
INFO="Test download"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path={"$HOST","test-package","repository-alias"} \
    type=s value="salt"
assert_run

# remove pkg
CMD="pkg.remove test-package"
INFO="remove the test-package"
describe "\${CMD}" "\${INFO}"
$SALT_CALL $CMD --out json | bin/jsontest path={"$HOST","test-package","new"} \
    type=s value=""
assert_run


