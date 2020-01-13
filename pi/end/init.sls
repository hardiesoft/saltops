'date "+%Y-%m-%d %H:%M:%S" > /etc/cacophony/last-salt-update':
  cmd.run

'systemctl stop stay-on':
  cmd.run
