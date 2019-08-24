base_pkg:
  pkg.installed:
    - names:
      - openssl
      - openssl-devel
      - vim-enhanced
      - net-tools
      - wget
chrony-install:
  pkg.installed:
    - name: chrony
chrony-config:
  file.managed:
    - name: /etc/chrony.conf
    - source: salt://openstack-queens/base/files/chrony.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: chrony-install
  service.running:
    - name: chronyd
    - enable: True
    - require:
      - file: chrony-config
sync-time:
  cmd.run:
    - name: chronyc sources
    - require:
      - service: chrony-config
openstack-repo:
  pkg.installed:
    - name: centos-release-openstack-queens
openstack-python-client:
  pkg.installed:
    - name:  python2-openstackclient
script-init:
  file.managed:
    - name: /etc/init.d/script
    - source: salt://openstack-queens/base/files/script
    - mode: 755
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      db_root_passwd: {{ pillar['databases']['root']['password'] }}
      db_openstack_passwd: {{ pillar['databases']['openstack']['password'] }}
      db_keystone_passwd: {{ pillar['databases']['keystone']['password'] }}
      db_glance_passwd: {{ pillar['databases']['glance']['password'] }}
      db_nova_passwd: {{ pillar['databases']['nova']['password'] }}
      db_neutron_passwd: {{ pillar['databases']['neutron']['password'] }}
      db_cinder_passwd: {{ pillar['databases']['cinder']['password'] }}
      keystone_admin_pass: {{ pillar['databases']['keystone']['admin_pass'] }}
      neutron_ip: {{ pillar['databases']['neutron']['neutron_host'] }}
