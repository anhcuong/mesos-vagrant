# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.define "salt-master" do |master|
    master.vm.box = "ubuntu/trusty64"    
    master.vm.network "private_network", ip: "192.168.32.100"
    master.vm.hostname = "salt-master"    
    master.vm.provision "shell", inline: <<-SHELL
    sudo -s    
    sed -i 's/127.0.1.1/'$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)'/g' /etc/hosts      
    add-apt-repository ppa:saltstack/salt
    apt-get update && apt-get install -y salt-master
    killall salt-master
    echo "file_roots:" $'\n' "base: " $'\n' "- /vagrant/ " >> /etc/salt/master 
    echo "master: 192.168.32.100" >> /etc/salt/minion
    salt-master -d    
  SHELL
  end

  (1..2).each do |i|
    config.vm.define "mesos-slave-#{i}" do |slave|
      slave.vm.box = "ubuntu/trusty64"      
      slave.vm.network "private_network", ip: "192.168.32.#{i+1}"
      slave.vm.hostname = "mesos-slave-#{i}"
      slave.vm.provider "virtualbox" do |vb|      
      vb.memory = 1024
    end
    slave.vm.provision "shell", inline: <<-SHELL
      sudo -s
      sed -i 's/127.0.1.1/'$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)'/g' /etc/hosts      
      add-apt-repository ppa:saltstack/salt
      apt-get update
      apt-get install -y salt-minion
      echo "master: 192.168.32.100" >> /etc/salt/minion
      salt-minion -d  
    SHELL
    end
  end

  (3..5).each do |i|
    config.vm.define "mesos-master-slave-#{i}" do |slave|
      slave.vm.box = "ubuntu/trusty64"      
      slave.vm.network "private_network", ip: "192.168.32.#{i+1}"
      slave.vm.hostname = "mesos-master-slave-#{i}"
      slave.vm.provider "virtualbox" do |vb|      
      vb.memory = 2048
    end
    slave.vm.provision "shell", inline: <<-SHELL
      sudo -s
      sed -i 's/127.0.1.1/'$(/sbin/ifconfig eth1 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)'/g' /etc/hosts      
      add-apt-repository ppa:saltstack/salt
      apt-get update
      apt-get install -y salt-minion
      echo "master: 192.168.32.100" >> /etc/salt/minion
      salt-minion -d      
    SHELL
    end
  end
end
