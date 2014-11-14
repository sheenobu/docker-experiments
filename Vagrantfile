# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos7.box"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.hostname = "docker1.local"
  config.vm.synced_folder ".", "/opt/docker"
  config.vm.provider "virtualbox" do |vb|
     vb.customize ["modifyvm", :id, "--memory", "2048"]
  end
end
