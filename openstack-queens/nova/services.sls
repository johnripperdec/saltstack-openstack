nova_rerequisites:
  cmd.run:
    - name: /etc/init.d/script nova_api && /etc/init.d/script nova && /etc/init.d/script nova_cell0

nova_credentials:
  cmd.run:
    - name: /etc/init.d/script nova_credentials

include:
  - openstack-queens.nova.install

/etc/nova/nova.conf:
  file.managed:
    - source: salt://openstack-queens/nova/files/nova.conf
    - template: jinja
    - defaults:
      nova_db_passwd: {{ pillar['databases']['nova']['password'] }}
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      db_openstack_passwd: {{ pillar['databases']['openstack']['password'] }}
      nova_db_user: {{ pillar['databases']['nova']['username'] }}
      nova_db_name: {{ pillar['databases']['nova']['db_name'] }}
      nova_db_api_name: {{ pillar['databases']['nova']['service'] }}
      neutron_ip: {{ pillar['databases']['neutron']['neutron_host'] }}

/usr/lib64/python2.7/logging/__init__.py:
  file.managed:
    - source: salt://openstack-queens/nova/files/__init__.py
    - user: root
    - group: root
    - mode: 644
add_http_nova-config:
  file.managed:
    - name: /opt/add_http_nova.sh
    - source: salt://openstack-queens/nova/files/add_http_nova.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && /bin/bash add_http_nova.sh && systemctl restart httpd
    - unless: cat 00-nova-placement-api.conf |grep Require
nova_populate_db:
  cmd.run:
    - name: /etc/init.d/script nova_populate_db
nova-api-service:
  service.running:
    - name: openstack-nova-api
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
nova-conauth-service:
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
nova-scheduler-service:
  service.running:
    - name: openstack-nova-scheduler
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
nova-conductor-service:
  service.running:
    - name: openstack-nova-conductor 
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf
nova-vnc-service:
  service.running:
    - name: openstack-nova-novncproxy 
    - enable: True
    - watch:
      - file: /etc/nova/nova.conf

