# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define the different servers that we want to create.
# Start with a webserver.
#
# To Do:
# Inventory server
# Test webserver
hosts = {
  "web.local" => "192.168.33.20",
}

# All Vagrant configuration is done below.
# The "2" in Vagrant.configure configures the configuration version.
# Please don't change it unless you know what you're doing.
Vagrant.configure(2) do |config|
  hosts.each do |name, ip|
    config.vm.define name do |machine|
      machine.vm.box = "bento/centos-6.7"
      machine.vm.box_url = "https://atlas.hashicorp.com/bento/boxes/centos-6.7"
      machine.vm.hostname = "%s" % name
      machine.vm.network :private_network, ip: ip
      machine.vm.provider "virtualbox" do |v|
        v.name = name
        if name.include? "web.local"
          v.customize ["modifyvm", :id, "--memory", 2048]
        else
          v.customize ["modifyvm", :id, "--memory", 1024]
        end
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
    end
    #sync folders
    config.vm.synced_folder "~/data", "/data", type: "nfs"
    config.vm.synced_folder "~/data/files", "/wwwng/sitefiles", type: "nfs"
  end
end
