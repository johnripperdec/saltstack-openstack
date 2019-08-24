include:
  - openstack-queens.memcached.install

memcached_service:
  file.managed:
    - name: /etc/sysconfig/memcached
    - source: salt://openstack-queens/memcached/files/memcached
    - mode: 755
  service.running:
    - name: memcached
    - enable: true
    - require:
      - file: memcached_service
    - watch:
      - file: /etc/sysconfig/memcached
