# Get file from master
/etc/supervisor/supervisord.conf: 
  file: 
    - managed
    - 
      source: "salt://mesos_config/minion-supervisord.conf"

run_supervisor:
  service.running:
    - name: supervisor
    - enable: True