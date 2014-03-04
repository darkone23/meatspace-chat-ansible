#!/bin/bash

set -e

source .digital-ocean-credentials
curl -s https://raw.github.com/ansible/ansible/devel/plugins/inventory/digital_ocean.py > ansible/dohosts
chmod +x ansible/dohosts

function create_droplet() {
    if [ ! $# = 2 ]
    then
       echo "usage: ./digital-ocean.sh create region_id size_id"
       exit 1
    fi
    ansible-playbook -i localhost, ansible/droplet.yaml -e region=$1 -e size=$2 -c local
    ansible-playbook -i ansible/dohosts ansible/provision.yaml -u root
    ansible-playbook -i ansible/dohosts ansible/deploy.yaml -u meat
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
    create_droplet $@
    ;;
"destroy")
    shift
    destroy_droplet $@
    ;;
*) echo "Usage: ./digital-ocean.sh [regions|sizes|images|ssh_keys]"
   ;;
esac
