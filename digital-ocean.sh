#!/bin/bash

set -e

function dependencies() {
    # checking for dependencies
    which ansible-galaxy ansible-playbook curl > /dev/null
    python -c 'import dopy'

    if [ -n "${DO_API_KEY}" ]; then
        source .digital-ocean-credentials
    fi

    if [ ! -d ansible/roles/eggsby.supervise ]; then
        ansible-galaxy install -r ansible/roles.txt -p ansible/roles --force
    fi

    if [ ! -x ansible/dohosts ]; then
        curl -s https://raw.github.com/ansible/ansible/devel/plugins/inventory/digital_ocean.py > ansible/dohosts
        chmod +x ansible/dohosts
    fi
}

function provision_droplet() {
    ansible-playbook -i ansible/dohosts ansible/provision.yaml -u root
}

function deploy_droplet() {
    ansible-playbook -i ansible/dohosts ansible/deploy.yaml -u meat
}

function create_droplet() {
    if [ ! $# = 2 ]
    then
       echo "usage: ./digital-ocean.sh create region_id size_id"
       exit 1
    fi

    ansible-playbook -i localhost, ansible/droplet.yaml -e region=$1 -e size=$2 -c local
    provision_droplet
    deploy_droplet
    echo "Your meatspace chat is now available at the above IP"
}

function destroy_droplet() {
    if [ ! $# = 1 ]
    then
       echo "usage: ./digital-ocean.sh destroy droplet_id"
       exit 1
    fi
    ansible-playbook -i localhost, ansible/droplet.yaml -e state=absent -e id=$1 -c local
    echo "Successfully destroyed droplet"
}

case "$1" in

"regions")  
    url=`printf "https://api.digitalocean.com/%s/?client_id=%s&api_key=%s" $1 $DO_CLIENT_ID $DO_API_KEY`
    curl -s $url | python -mjson.tool
    ;;
"sizes")  
    url=`printf "https://api.digitalocean.com/%s/?client_id=%s&api_key=%s" $1 $DO_CLIENT_ID $DO_API_KEY`
    curl -s $url | python -mjson.tool
    ;;
"images")  
    url=`printf "https://api.digitalocean.com/%s/?client_id=%s&api_key=%s" $1 $DO_CLIENT_ID $DO_API_KEY`
    curl -s $url | python -mjson.tool
    ;;
"ssh_keys")  
    url=`printf "https://api.digitalocean.com/%s/?client_id=%s&api_key=%s" $1 $DO_CLIENT_ID $DO_API_KEY`
    curl -s $url | python -mjson.tool
    ;;
"create")
    shift
    dependencies
    create_droplet $@
    ;;
"destroy")
    shift
    dependencies
    destroy_droplet $@
    ;;
"provision")
    shift
    dependencies
    provision_droplet $@
    ;;
"deploy")
    shift
    dependencies
    deploy_droplet $@
    ;;
*) echo "Usage: ./digital-ocean.sh [create|destroy|regions|sizes|images|ssh_keys]"
   ;;
esac
