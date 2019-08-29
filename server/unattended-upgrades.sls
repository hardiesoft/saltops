unattended-upgrades:
   pkg.installed

/etc/apt/apt.conf.d/20auto-upgrades:
  file.managed:
    - source: salt://server/20auto-upgrades

/etc/apt/apt.conf.d/50unattended-upgrades:
  file.managed:
    - source: salt://server/50unattended-upgrades
