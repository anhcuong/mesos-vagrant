# Get file from master
/opt/mesos-0.23.0.tar: 
  file: 
    - managed
    - 
      source: "salt://mesos_config/mesos-0.23.0.tar"

/opt/zookeeper-3.4.6.tar.gz: 
  file: 
    - managed
    - 
      source: "salt://mesos_config/zookeeper-3.4.6.tar.gz"

/opt/marathon-0.10.0.tgz: 
  file: 
    - managed
    - 
      source: "salt://mesos_config/marathon-0.10.0.tgz"


# Install Marathon
marathon.repo:
  pkgrepo.managed:
    - humanname: Marathon mesos
    - name: deb http://repos.mesosphere.io/ubuntu trusty main
    - dist: trusty
    - file: /etc/apt/sources.list.d/mesosphere.list
    - keyid: E56151BF
    - keyserver: keyserver.ubuntu.com

# Install dependencies
mesos_pkgs: 
  pkg.installed: 
    - 
      pkgs: 
        - openjdk-7-jdk
        - autoconf
        - libtool
        - build-essential
        - python-dev
        - python-boto
        - libcurl4-nss-dev
        - libsasl2-dev
        - maven
        - libapr1-dev
        - libsvn-dev         
# Bug in salt with pip cannot put into above package
python-pip:
  pkg.installed

# Start supervisord server
supervisor:
  pkg.installed

# Get the latest docker
docker-install: 
  cmd: 
    - run 
    - name: "curl -sSL https://get.docker.com/ | sh"    

# extract mesos files
{% if not salt['file.directory_exists']('/opt/mesos-0.23.0') %}
mesos-archive: 
  cmd: 
    - run 
    - name: "/bin/tar xf /opt/mesos-0.23.0.tar -C /opt/" 
    - require: 
      - file:  /opt/mesos-0.23.0.tar
{% endif %}

# extract zookeeper files
{% if not salt['file.directory_exists']('/opt/zookeeper-3.4.6') %}
zookeeper-archive: 
  cmd: 
    - run 
    - name: "/bin/tar xzf /opt/zookeeper-3.4.6.tar.gz -C /opt/" 
    - require: 
      - file:  /opt/zookeeper-3.4.6.tar.gz
{% endif %}

# extract marathon files
{% if not salt['file.directory_exists']('/opt/marathon-0.10.0') %}
mesos-archive: 
  cmd: 
    - run 
    - name: "/bin/tar xzf /opt/marathon-0.10.0.tgz -C /opt/" 
    - require: 
      - file:  /opt/marathon-0.10.0.tgz
{% endif %}

# Create running folder
{% if not salt['file.directory_exists' ]('/var/run/mesos') %}
/var/run/mesos:
  file.directory:    
    - name:  /var/run/mesos    
{% endif %}

{% if not salt['file.directory_exists' ]('/var/zookeeper/') %}
/var/zookeeper:
  file.directory:    
    - name:  /var/zookeeper/    
{% endif %}

{% if salt['file.directory_exists']('/var/zookeeper/') %}
zookeeper-myid: 
  cmd: 
    - run 
    - name: "echo $(hostname | grep -o '[0-9]*') > /var/zookeeper/myid"    
{% endif %}

/opt/zookeeper-3.4.6/conf/zoo.cfg: 
  file: 
    - managed
    - 
      source: "salt://mesos_config/zoo.cfg"

/usr/lib/libmesos.so:
  file.copy:
    - source: "/opt/mesos-0.23.0/build/src/.libs/libmesos.so"

