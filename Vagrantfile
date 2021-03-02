# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "centos/8"

  # # Add proxy config to VM
  # if Vagrant.has_plugin?("vagrant-proxyconf")
  #   config.proxy.http     = "http://172.16.0.28:8080/"
  #   config.proxy.https    = "http://172.16.0.28:8080/"
  #   config.proxy.ftp      = "http://172.16.0.28:8080"
  #   config.proxy.no_proxy = "localhost,127.0.0.1"
  # end

  # Add current user ssh public key to VM
  config.vm.provision "file", source: "~/.ssh/id_ed25519.pub", destination: "/home/vagrant/id_ed25519.pub"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/id_ed25519.pub >> /home/vagrant/.ssh/authorized_keys
    rm /home/vagrant/id_ed25519.pub
  SHELL

  config.vm.provider "virtualbox" do |server|
    server.memory = "2048"
  end

  config.vm.define "jenkins", primary: true do |server|
    server.vm.hostname = "jenkins.test"
    server.vm.network "private_network", ip: "192.168.100.11"
  end

  config.vm.define "sonarqube" do |server|
    server.vm.hostname = "sonarqube.test"
    server.vm.network "private_network", ip: "192.168.100.12"
  end

  config.vm.define "appserver" do |server|
    server.vm.hostname = "appserver.test"
    server.vm.network "private_network", ip: "192.168.100.13"
  end
end