#!/bin/sh

set -e

# check that we have the required dependencies
which vagrant ansible-playbook ansible-galaxy > /dev/null

# install meatspace-chat into a vm, exposed on localhost:8080
if [ ! -d ansible/roles/eggsby/supervise ]; then
    ansible-galaxy install -r ansible/roles.txt -p ansible/roles -f
fi

vagrant up
vagrant provision
