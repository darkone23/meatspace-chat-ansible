### Meatspace-Chat Ansible

You can use this to install meatspace-chat on debian flavor boxes.
Point it at your droplets, or your VMs, or whatever

## Vagrant

If you have vagrant and want to try meatspace-chat in a vm:

`./install.sh`

This will take a while.. it downloads a server image from ubuntu, then installs a bunch of packages.

Go somewhere else until this thing finishes.

By the end of the process you should have a production quality meatspace-chat running in a vm, forwarded on localhost:8080

## Checking it out

visit [http://localhost:8080](your local instance)

or `ssh meat@localhost -p 2222`

Happy chats
