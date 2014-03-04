#!/bin/bash

set -e

source .digital-ocean-credentials
curl -s https://raw.github.com/ansible/ansible/devel/plugins/inventory/digital_ocean.py > ansible/dohosts

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
*) echo "Usage: ./digital-ocean.sh [regions|sizes|images|ssh_keys]"
   ;;
esac
