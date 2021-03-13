# -*- mode: ruby -*-
# vi: set ft=ruby :

cluster = {
  "jenkins" => { :ip => "192.168.100.11", :mem => 2048, :cpu => 2 },
  "sonarqube" => { :ip => "192.168.100.12", :mem => 2048, :cpu => 2 },
  "appserver" => { :ip => "192.168.100.13", :mem => 2048, :cpu => 2 }
}

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.provision "shell", inline: "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKBYP8WLbAudznHNukAktWyDL1I0N5Wn8hus/re3ncI8' >> /home/vagrant/.ssh/authorized_keys"

  cluster.each_with_index do |(hostname, info), index|
    config.vm.define hostname do |cfg|
      cfg.vm.provider :virtualbox do |vb, override|
        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname + ".test"
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpu], "--hwvirtex", "on"]
      end # end provider
    end # end config
  end # end cluster

end
