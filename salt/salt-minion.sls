# If this changes we need to manually restart the salt minion afterwards
/etc/salt/minion:
  file.managed:
    - source: salt://salt-minion/minion
