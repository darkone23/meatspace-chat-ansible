## meatspace-chat ansible

You can use this to install [meatspace-chat](https://github.com/meatspaces/meatspace-chat) on ubuntu servers.

Point it at your droplets, or your VMs, or whatever.

### Dependencies

The only hard dependency is ansible and a unix-like host (osx, linux, etc). Most of the time you can install ansible with:

    sudo pip install ansible

### Configuration

You can configure your meatspace instance by tweaking the settings in your ansible [group vars](https://github.com/eggsby/meatspace-chat-ansible/blob/master/ansible/group_vars/all)

### Deploying with Vagrant

If you have vagrant and virtualbox installed locally you can deploy to a VM:

    ./vagrant.sh

This will take a while.. it downloads a server image from ubuntu, then installs a bunch of packages.

Go somewhere else until this thing finishes.

By the end of the process you should have meatspace-chat running in a vm, forwarded to [localhost:8080](http://localhost:8080)


### Deploying to Digital Ocean

#### Setup

Using the digital ocean python library you can spin up meatspace chat instances. Make sure you have the digital ocean library:

    sudo pip install dopy

You will also need to provide your client id and api key, put them in a file named `.digital-ocean-credentials` with the contents:

```sh
#!/bin/sh

export DO_API_KEY="MY_API_KEY"
export DO_CLIENT_ID="MY_CLIENT_ID"
```

#### Deployment

To spin up a new meatspace-chat droplet provide the region id and desired droplet size.

    # ./digital-ocean.sh create <region-id> <size-id>
    ./digital-ocean.sh create 1 66

This will create a 512MB droplet in NYC.

Visit the IP after it finished provisioning and visit your new meatspace-chat!

If you ever want to update your instance to the latest version & configuration:

    ./digital-ocean.sh deploy

#### Teardown

You can use the droplet id to tear down the instances as well:

```
./digital-ocean.sh destroy <droplet-id>
```

Check for other sizes and regions using the script:

```
./digital-ocean.sh regions
./digital-ocean.sh sizes
```


### Deploying over SSH

It's also possible to deploy directly to an existing ubuntu server over SSH.

**warning, this will install packages and configuration at the system level, don't do this unless you know what you are doing**

Create a file named `hosts` with the contents:

```
[meatspace-chat]
your.server.name
```

Then run the ansible steps:

```sh
ansible-galaxy install -r ansible/roles.txt -p ansible/roles
ansible-playbook -i hosts ansible/provision.yaml
ansible-playbook -i hosts ansible/deploy.yaml -u meat
```

You may need to provide credentials for provisioning if your system requires it `ansible-playbook -kK`

Now, if you just want to update the running version of meatspace:

```sh
ansible-playbook -i hosts ansible/deploy.yaml -u meat
```

Happy chats!
