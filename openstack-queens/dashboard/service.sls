include:
  - openstack-queens.dashboard.install

/etc/openstack-dashboard/local_settings:
  file.managed:
    - source: salt://openstack-queens/dashboard/files/local_settings
dashboard_service:
  cmd.run:
    - name: systemctl restart httpd.service memcached.service
