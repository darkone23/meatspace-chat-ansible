#!/bin/sh

set -e

# install meatspace-chat into a vm, exposed on localhost:8080
ansible-galaxy install eggsby.supervisor eggsby.supervise -f
vagrant up
vagrant provision
