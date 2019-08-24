admin-openrc:
  file.managed:
    - name: /root/admin-openrc
    - source: salt://openstack-queens/service_entity/files/admin-openrc
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      keys_pass: {{ pillar['databases']['keystone']['admin_pass'] }}
demo-openrc:
  file.managed:
    - name: /root/demo-openrc
    - source: salt://openstack-queens/service_entity/files/demo-openrc
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      demo_passwd: {{ pillar['user_info']['demo']['demo_passwd'] }}

service_entity:
  cmd.run:
    - name: /etc/init.d/script service_entity

service_neutron:
  cmd.run:
    - name: /etc/init.d/script neutron
endpoint-create:
  cmd.run:
    - name: /etc/init.d/script neutron_credentials
