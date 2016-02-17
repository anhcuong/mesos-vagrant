## Introduction
Installing mesos cluster using vagrant, saltstack.
Cluster includes 1 salt master + 4 salt slaves (5 mesos-slave and 3 mesos-master)
Building a HA cluster Mesos with Marathon and Docker
You can definitely modify the script to change mesos and marathon to the latest version. At the time of writing, I hardcoded most of values for fast setup.

## Prerequisite
Download marathon-0.10.0.tgz and mesos-0.23.0.tar into mesos_config/ folder since the binaries are too big to commit.

## Build Run

```sh
cd $PROJECT_ROOT
vagrant up
vagrant ssh salt-master
sudo -s
salt -v "*" state.highstate

# Wait for few minutes

```

## Contacts
[Frank Tran](https://github.com/anhcuong)