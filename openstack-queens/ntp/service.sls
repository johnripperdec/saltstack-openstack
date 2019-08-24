ntp_installed:
  pkg.installed:
    - pkgs:
      - chrony

ntp_running:
  file.managed:
    - name: /etc/chrony.conf
    - source: salt://ntp/files/chrony.conf
    - template: jinja
    - defaults:
      ntp_server: {{ pillar['chrony_info']['chrony']['ntp_server'] }}
      allow_host: {{ pillar['chrony_info']['chrony']['allow_host'] }}

  service.running:
    - name: chronyd
    - enable: True
    - watch:
      - file: /etc/chrony.conf

sync_time:
  cmd.run:
    - name: chronyc sources
