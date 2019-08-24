include:
  - openstack-queens.glance.install

glance_prerequisites:
  cmd.run:
    - name: /etc/init.d/script glance_prerequisites

glance_service:
  file.managed:
    - name: /etc/glance/glance-api.conf
    - source: salt://openstack-queens/glance/files/glance-api.conf
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      GLANCE_USER: {{ pillar['databases']['glance']['username'] }}
      GLANCE_PASSWORD: {{ pillar['databases']['glance']['password'] }}
      GLANCE_DBANAME: {{ pillar['databases']['glance']['db_name'] }}

/etc/glance/glance-registry.conf:
  file.managed:
    - source: salt://openstack-queens/glance/files/glance-registry.conf
    - template: jinja
    - defaults:
      controller_ip: {{ pillar['info']['controller']['ip'] }}
      GLANCE_USER: {{ pillar['databases']['glance']['username'] }}
      GLANCE_PASSWORD: {{ pillar['databases']['glance']['password'] }}
      GLANCE_DBANAME: {{ pillar['databases']['glance']['db_name'] }}

glance_populate_image:
  cmd.run:
    - name: /etc/init.d/script glance_populate_image

glance_create_credentials:
  cmd.run:
    - name: /etc/init.d/script glance_create_credentials

glance_api.run:
  service.running:
    - name: openstack-glance-api
    - enable: true
    - watch: 
      - file: /etc/glance/glance-api.conf

glance_registry.run:
  service.running:
    - name: openstack-glance-registry
    - enable: true
    - watch:
      - file: /etc/glance/glance-registry.conf

image_sync:
  file.managed:
    - name: /tmp/cirros-0.3.4-x86_64-disk.img
    - source: salt://openstack-queens/glance/files/cirros-0.3.4-x86_64-disk.img

glance_upload_image:
  cmd.run:
    - name: /etc/init.d/script glance_upload_image
    - require:
      - file: image_sync
      - service: glance_registry.run
      - service: glance_api.run
