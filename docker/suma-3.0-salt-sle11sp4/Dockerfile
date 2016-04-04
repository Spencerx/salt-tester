# Container used to test cobbler against suse manager head
#
# NAME                  suma-3.0-salt-sle11sp4
# VERSION               1.0.0

FROM suma-docker-registry.suse.de/sles11sp4:0.1.0
MAINTAINER Michael Calmer "mc@suse.com"


# Add the repositories
ADD add_repositories.sh /root/add_repositories.sh
RUN /root/add_repositories.sh

# Install the packages required to run the cobbler tests
ADD add_packages.sh /root/add_packages.sh
RUN /root/add_packages.sh

