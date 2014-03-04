# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-precise-server-amd64"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/provision.yaml"
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/deploy.yaml"
    ansible.raw_arguments = '--private-key=~/.ssh/id_rsa'
    ansible.extra_vars = { ansible_ssh_user: 'meat' }
  end
end
