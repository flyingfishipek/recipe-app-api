# -*- mode: ruby -*-
# vi: set ft=ruby :

##############################################################################
#                 Ubuntu VM with Docker and Docker Compose
##############################################################################
Vagrant.configure("2") do |config|

    config.vm.box = "ubuntu/bionic64"

    config.vm.network "private_network", ip: "192.168.50.10", hostname: true
    config.vm.network "forwarded_port", guest: 8000, host: 8000

    # require plugin https://github.com/leighmcculloch/vagrant-docker-compose
    config.vagrant.plugins = "vagrant-docker-compose"

    # install docker and docker-compose
    config.vm.provision :docker
    config.vm.provision :docker_compose

    config.vm.synced_folder "./", "/vagrant", owner: "root", group: "root"
end
