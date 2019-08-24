mysql-server:
  pkg.installed:
    - names:
      - mariadb
      - mariadb-server
      - python2-PyMySQL

  file.managed:
    - name: /etc/my.cnf
    - source: salt://openstack-queens/mysql/files/my.cnf
    - template: jinja
    - defaults:
      MYSQL_HOST: {{ pillar['mysql']['mysql-host'] }}

  service.running:
    - name: mariadb
    - enable: True
    - require:
      - pkg: mysql-server
    - watch:
      - file: mysql-server
mysql_passwd:
  file.managed:
    - name: /opt/my_passwd.sh
    - source: salt://openstack-queens/mysql/files/my_passwd.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      db_root_passwd: {{ pillar['mysql']['password'] }}
    - unless: test -f /opt/my_passwd.sh
  cmd.run:
    - name: cd /opt && /bin/bash my_passwd.sh
    - require:
      - service: mysql-server 
