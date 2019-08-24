include:
  - openstack-queens.keystone.install
keystone_service:
  file.managed:
    - name: /etc/keystone/keystone.conf
    - source: salt://openstack-queens/keystone/files/keystone.conf
    - template: jinja
    - defaults:
      KEYSTONE_USER: {{ pillar['databases']['keystone']['username'] }}
      KEYSTONE_PASS: {{ pillar['databases']['keystone']['password'] }}
      KEYSTONE_DBNAME: {{ pillar['databases']['keystone']['db_name'] }}
      MYSQL_HOST: {{ pillar['info']['controller']['ip'] }}
    - require:
      - pkg: keystone_install
keystone_db_sync:
  cmd.run:
    - name: /etc/init.d/script keystone_prerequisites && /etc/init.d/script keystone_ropulate && /etc/init.d/script keystone_bootstrap
httpd_services:
    file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://openstack-queens/keystone/files/httpd.conf
    - template: jinja
    - defaults:
      httpd_ip: {{ pillar['info']['controller']['ip'] }}

wsgi_keystone:
  cmd.run:
    - name: ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
httpd.run:
  service.running:
    - name: httpd
    - enable: true
    - watch: 
      - file: httpd_services
