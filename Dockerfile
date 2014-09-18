############################################################
# Dockerfile for ScriptRock mDNS based auto-clustering
############################################################

# Set the base image to use to Ubuntu
FROM ubuntu:14.04

# Set the file maintainer
MAINTAINER Mark Sheahan <mark.sheahan@scriptrock.com>

# install necessary stuff; avahi, and ssh such that we can log in and control avahi
RUN apt-get update
RUN apt-get install -y openssh-server avahi-daemon avahi-utils

# this container is run with --net=host, so we must change ports for sshd
RUN sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config

# workaround to get dbus working, required for avahi to talk to dbus. This will be mounted
RUN mkdir -p /var/run/dbus
RUN mkdir -p /mnt/keys
VOLUME ["/var/run/dbus", "/mnt/keys"]

# login keys come in through a volume; we intend to log into root on this to run commands
RUN mkdir /root/.ssh/
RUN ln -s /mnt/keys/id_rsa.pub /root/.ssh/authorized_keys

ENTRYPOINT /bin/bash -c 'service ssh restart && avahi-daemon --no-drop-root'

