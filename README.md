## meatspace-chat ansible

You can use this to install [meatspace-chat](https://github.com/meatspaces/meatspace-chat) on debian flavor boxes.
Point it at your droplets, or your VMs, or whatever

### Configuration

You can configure your instance by tweaking the settings in your ansible [group vars](https://github.com/eggsby/meatspace-chat-ansible/blob/master/ansible/group_vars/all)

### Deploying with Vagrant

If you have vagrant and ansible installed locally you can deploy to a VM:

`./vagrant.sh`

This will take a while.. it downloads a server image from ubuntu, then installs a bunch of packages.

Go somewhere else until this thing finishes.

By the end of the process you should have a production quality meatspace-chat running in a vm, forwarded to localhost:8080

#### Checking it out

visit [your local meat-chat](http://localhost:8080)

or `ssh meat@localhost -p 2222`


### Deploying to Digital Ocean

Make sure you have a digital ocean client id and api key: use them to create a file named `.digital-ocean-credentials` with the contents:

```
#!/bin/sh

export DO_API_KEY="MY_API_KEY"
export DO_CLIENT_ID="MY_CLIENT_ID"
```

Then create a new instance, providing the region id and desired droplet size. You will need ansible & dopy installed.

```
# ./digital-ocean.sh create <region-id> <size-id>
./digital-ocean.sh create 1 66
```

This will create a 512 instance in NYC. Visit the IP after it is all done and visit your meatspace!

To tear it down:

```
./digital-ocean.sh destroy <droplet-id>
```

Check for other sizes and regions using the script:

```
./digital-ocean.sh regions
./digital-ocean.sh sizes
```


### Deploying over SSH

**warning, this will install packages and configuration at the system level, don't do this unless you know what you are doing**

Create a file named `hosts` with the contents:

```
[meatspace-chat]
your.server.name
```

Then run ansible:

```sh
ansible-galaxy install -r ansible/roles.txt -p ansible/roles
ansible-playbook -i hosts ansible/provision.yaml
ansible-playbook -i hosts ansible/deploy.yaml -u meat
```

You may need to provide credentials if your system requires it `ansible-playbook -kK`

Or, if you just want to update the running version of meatspace:

```sh
ansible-playbook -i hosts ansible/deploy.yaml -u meat
```

Happy chats
