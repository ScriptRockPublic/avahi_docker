#!/bin/sh

set -e
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i /etc/scriptrock/keys/login/avahi/id_rsa -p 2222 root@localhost $*

