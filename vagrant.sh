#!/bin/sh

set -e

# check that we have the required dependencies
which vagrant ansible-playbook ansible-galaxy

# install meatspace-chat into a vm, exposed on localhost:8080
ansible-galaxy install -r ansible/roles.txt -p ansible/roles -f
vagrant up
vagrant provision
