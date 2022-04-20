# -*- mode: ruby -*-
# vi: set ft=ruby :

QTD_MAQUINAS = 2
BOX_PADRAO = "ubuntu/focal64"
SCRIPT = <<-SHELL
  apt-get update
  apt-get install -y nginx
  rm /var/www/html/index.nginx-debian.html
  cp /persistencia/index.nginx-debian.html /var/www/html/
SHELL

Vagrant.configure("2") do |config|
  config.vm.box = BOX_PADRAO
  
  config.vm.box_version = "=20220411.2.0"

  config.vm.define "bd" do |vmbd|
    
    vmbd.vm.network "private_network", ip: "172.28.128.10"

    vmbd.vm.network "forwarded_port", guest: 5432, host: 5434

    vmbd.vm.synced_folder "dados", "/persistencia"

    vmbd.vm.provider "virtualbox" do |vb|
      vb.name = "VM_Postgres"
      vb.memory = "1024"
      vb.cpus = 1  
    end
    
    vmbd.vm.provision "docker" do |docker|
      docker.run "bitnami/postgresql:10.19.0", args: "--name postgresql -p 5432:5432 -e POSTGRESQL_USERNAME=usr -e POSTGRESQL_PASSWORD=pass -e POSTGRESQL_DATABASE=db"
    end
  end

  (1 .. QTD_MAQUINAS).each do |n|
    config.vm.define "app#{n}" do |vmapp|
          
      vmapp.vm.network "private_network", ip: "172.28.128.1#{n}"

      vmapp.vm.network "forwarded_port", guest: 80, host: "808#{n}"

      vmapp.vm.network "public_network", bridge: "enp2s0"

      vmapp.vm.synced_folder "dados", "/persistencia"

      vmapp.vm.synced_folder ".", "/vagrant", disable: true;

      vmapp.vm.provider "virtualbox" do |vb|
        vb.name = "VM_Application#{n}"
        vb.memory = "1024"
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--cpuexecutioncap","50"]
      end

      vmapp.vm.provision "shell", inline: SCRIPT

      vmapp.vm.provision "shell", path: "install_nodejs.sh" 
    end
  end
end
