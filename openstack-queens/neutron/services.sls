include:
  - openstack-queens.neutron.install
/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://openstack-queens/neutron/files/neutron.conf
    - user: root
    - group: neutron
    - mode: 644
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://openstack-queens/neutron/files/ml2_conf.ini
    - user: root
    - group: neutron
    - mode: 644
/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  file.managed:
    - source: salt://openstack-queens/neutron/files/linuxbridge_agent.ini
    - user: root
    - group: neutron
    - mode: 644
/etc/neutron/dhcp_agent.ini:
  file.managed:
    - source: salt://openstack-queens/neutron/files/dhcp_agent.ini
    - user: root
    - group: neutron
    - mode: 644
/etc/neutron/metadata_agent.ini:
  file.managed:
    - source: salt://openstack-queens/neutron/files/metadata_agent.ini
    - user: root
    - group: neutron
    - mode: 644
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
/usr/lib/python2.7/site-packages/tenacity/__init__.py:
  file.managed:
    - source: salt://openstack-queens/neutron/files/__init__.py
    - user: root
    - group: root
    - mode: 644
neutron-server-service:
  cmd.run:
    - name: ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini && su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
    - unless: test -f /etc/neutron/plugin.ini
  service.running:
    - name: neutron-server
    - enable: true
    - watch:
      - file: /etc/neutron/neutron.conf 
    - require:
      - cmd: neutron-server-service
neutron-linuxbridge-service:
  service.running:
    - name: neutron-linuxbridge-agent
    - enable: true
    - watch:
      - file: /etc/neutron/neutron.conf 
      - file: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
neutron-dhcp-agent-service:
  service.running:
    - name: neutron-dhcp-agent
    - enable: true
    - watch:
      - file: /etc/neutron/neutron.conf 
neutron-metadata-agent-service:
  service.running:
    - name: neutron-metadata-agent
    - enable: true
    - watch:
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/metadata_agent.ini 

      
