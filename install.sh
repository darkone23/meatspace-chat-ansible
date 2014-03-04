#!/bin/sh

set -e

# check that we have the required dependencies
which vagrant ansible-playbook ansible-galaxy

# install meatspace-chat into a vm, exposed on localhost:8080
ansible-galaxy install eggsby.supervisor eggsby.supervise -f -p ansible/roles
vagrant up
vagrant provision
