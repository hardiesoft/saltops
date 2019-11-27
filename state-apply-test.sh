#!/bin/bash



device=$1
params=$2

if [[ -z $device ]]; then
  echo "please provide device name"
  exit 1
fi

# copy files to local folder
cp -r basics.sls _modules/ pi/ _states/ timezone.sls salt/

ssh pi@$device "sudo rm -rf salt /srv/salt"

# copy onto device
echo "copying files to device.."
scp -rq salt pi@$device:
echo "done"

echo "moving files to /srv"
ssh pi@$device "sudo cp -r salt /srv/"
echo "done"

cmd="ssh pi@$device \"sudo salt-call --local state.apply $params --state-output=mixed\""
echo "running $cmd"
eval $cmd
