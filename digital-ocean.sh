#!/bin/bash

set -e

function dependencies() {
    # checking for dependencies
    which ansible-galaxy ansible-playbook curl > /dev/null || (echo "Install required dependencies" && exit 1)
    python -c 'import dopy'

    if [ ! -n "${DO_API_KEY}" ]; then
        source .do
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
    ansible-playbook -i ansible/dohosts ansible/provision.yaml -u root $@
}

function deploy_droplet() {
    ansible-playbook -i ansible/dohosts ansible/deploy.yaml -u meat $@
}

function install_droplet() {
    provision_droplet $@
    deploy_droplet $@
}

function create_droplet() {
    if [ $# -lt 2 ]
    then
       echo "usage: ./digital-ocean.sh create region_id size_id"
       exit 1
    fi
    REGION=$1; shift
    SIZE=$1; shift
    ansible-playbook -i localhost, ansible/droplet.yaml -e region=$REGION -e size=$SIZE -c local $@
    install_droplet $@
    echo "Your meatspace chat is now available at the above IP"
}

function destroy_droplet() {
    if [ $# -lt 1 ]
    then
       echo "usage: ./digital-ocean.sh destroy droplet_id"
       exit 1
    fi
    ID=$1; shift
    ansible-playbook -i localhost, ansible/droplet.yaml -e state=absent -e id=$ID -c local $@
    echo "Successfully destroyed droplet"
}

dependencies

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
"provision")
    shift
    provision_droplet $@
    ;;
"deploy")
    shift
    deploy_droplet $@
    ;;
"install")
    shift
    install_droplet $@
    ;;
*)
    echo "Available commands: create, destroy, install, deploy, provision, regions, sizes, images, ssh_keys"
   ;;
esac
