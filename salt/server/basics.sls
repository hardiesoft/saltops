htop:
  pkg.installed

/etc/hosts:
  file.managed:
    - source: salt://server/hosts.jinja
    - template: jinja
