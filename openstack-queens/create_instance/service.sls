create-script:
  file.managed:
    - name: /root/create.sh
    - source: salt://openstack-queens/create_instance/files/create.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /root && /bin/bash create.sh
