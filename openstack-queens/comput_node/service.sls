include:
  - openstack-queens.comput_node.install

/etc/nova/nova.conf:
  file.managed:
    - source: salt://openstack-queens/comput_node/files/nova.conf
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      neutron_ip: {{ pillar['databases']['neutron']['neutron_host'] }}
      compute_host: {{ pillar['databases']['compute']['compute_host'] }}

comput_service:
  cmd.run:
    - name: systemctl enable libvirtd.service openstack-nova-compute.service && systemctl start libvirtd.service openstack-nova-compute.service

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://openstack-queens/comput_node/files/neutron.conf
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}

/usr/lib/python2.7/site-packages/tenacity/__init__.py:
  file.managed:
    - source: salt://openstack-queens/comput_node/files/__init__.py
    - user: root
    - group: root
    - mode: 644
/usr/lib64/python2.7/logging/__init__.py:
  file.managed:
    - source: salt://openstack-queens/comput_node/files/compute/__init__.py
    - user: root
    - group: root
    - mode: 644
/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  file.managed:
    - source: salt://openstack-queens/comput_node/files/linuxbridge_agent.ini
comput_neutron_service:
  cmd.run:
    - name: systemctl restart openstack-nova-compute.service
compute-service:
  service.running:
    - name:  openstack-nova-compute
    - enbale: true
linuxbridge-service:
  service.running:
    - name: neutron-linuxbridge-agent
    - enable: true
    - require:
      - cmd: comput_neutron_service
