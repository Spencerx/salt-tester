DOCKER_REGISTRY       = suma-docker-registry.suse.de
DOCKER_MOUNTPOINT     = /salt-tester
DOCKER_VOLUMES        = -v "$(CURDIR)/:$(DOCKER_MOUNTPOINT)"

all:	setup runtests teardown

setup:
	export OUTPUT_MODE="sparse"
	bash bin/teardown.sh
	bash bin/setup.sh

teardown:
	export OUTPUT_MODE="sparse"
	bash bin/teardown.sh

runtests:
	export OUTPUT_MODE="sparse"
	bash bin/tests.sh

jenkins: install setup runtests teardown

install:
	zypper mr -p 98 testpackages
	zypper --non-interactive in salt-master salt-minion
	zypper --non-interactive source-install -D salt
	zypper --non-interactive in --oldpackage test-package=42:0.0
	#
	# update libzypp and zypper
	#
	zypper --non-interactive up zypper libzypp

docker_tests-sle11sp4 ::
	docker run --rm $(DOCKER_VOLUMES) $(DOCKER_REGISTRY)/salt-sle11sp4 make -C $(DOCKER_MOUNTPOINT) jenkins

docker_tests-sle12sp1 ::
	docker run --rm $(DOCKER_VOLUMES) $(DOCKER_REGISTRY)/salt-sle12sp1 make -C $(DOCKER_MOUNTPOINT) jenkins

docker_shell-sle11sp4 ::
	docker run -t -i --rm $(DOCKER_VOLUMES) $(DOCKER_REGISTRY)/salt-sle11sp4 /bin/bash

docker_shell-sle12sp1 ::
	docker run -t -i --rm $(DOCKER_VOLUMES) $(DOCKER_REGISTRY)/salt-sle12sp1 /bin/bash
