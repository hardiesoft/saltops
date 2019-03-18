#!/bin/bash
# This script is used on prod-salt
# It uses wizzy to read the Grafana-dashboards and dump them
#     utkarshcmu.github.io/wizzy-site/home
# It will save them in a external objectstore for 10 days
# CopyLeft Huub, March 2019
# set -xv

MC=/usr/local/bin/mc
WIZZY=/usr/local/bin/wizzy
LOCALSTORE=/mnt/wizzy/dashboards
REMOTESTORE=/cacophony-backup/grafana-dashboards/
DAYS=10
TARFILE=$LOCALSTORE/dashboards-`date +%F`.tgz

# Make tar file of dashboards
$WIZZY import dashboards
tar czf $TARFILE $LOCALSTORE/*.json 

# Backup to external place 

$MC cp --quiet $TARFILE $REMOTESTORE 

# Cleaning up. Local just 1, remote just $DAYS
find $LOCALSTORE -name "*.tgz" -mtime $DAYS -delete
$MC find $REMOTESTORE -name "*.tgz" --older ${DAYS}d --exec "$MC rm {}"
