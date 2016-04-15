#!/bin/bash
set -e

# Use your credentials for the 'nu.novell' domain within the URL, in case required
zypper ar -f 'http://nu.novell.com/repo/$RCE/SLES11-SP3-Pool/sle-11-x86_64/' "SLES11 SP3 Pool"
zypper ar -f 'http://nu.novell.com/repo/$RCE/SLES11-SP3-Updates/sle-11-x86_64/' "SLES11 SP3 Updates"
zypper ar -f 'http://nu.novell.com/repo/$RCE/SLE11-SDK-SP3-Pool/sle-11-x86_64' "SLE-SDK11 SP3 Pool"
zypper ar -f 'http://nu.novell.com/repo/$RCE/SLE11-SDK-SP3-Updates/sle-11-x86_64' "SLE-SDK11 SP3 Updates"

zypper ar -f http://download.opensuse.org/repositories/systemsmanagement:/saltstack:/products/SLE_11_SP4/ "salt_testing"
zypper ar -f http://download.opensuse.org/repositories/systemsmanagement:/saltstack:/testing:/testpackages/SLE_11_SP4/ "testpackages"

zypper mr -p 98 salt_testing
zypper mr -p 98 testpackages
