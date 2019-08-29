/usr/local/bin/change-identity:
   file.absent

# Ensure that Dataplicity is uninstalled
supervisor:
  pkg.purged

supervisord:
  process.absent

dataplicity:
  process.absent

/opt/dataplicity:
  file.absent

/etc/supervisor:
  file.absent
