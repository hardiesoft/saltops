#!/usr/bin/python -u

"""
This tool subscribes to minion events from the Salt master and writes presence
events to InfluxDB. This is used to drive a Grafana dashboard.
"""

from datetime import datetime, timedelta
from influxdb import InfluxDBClient
from multiprocessing import Process
import salt.config
import salt.utils.event
import sys
import time


# Minions must ping or re-auth at least this period in order to be considered
# alive.
PRESENCE_INTERVAL = 5 * 60

# How often to check for dead minions to mark as such.
UPDATE_INTERVAL = 30


def main():
    opts = salt.config.client_config('/etc/salt/master')
    listener = salt.utils.event.get_event(
        'master',
        sock_dir=opts['sock_dir'],
        transport=opts['transport'],
        opts=opts)

    influx = influx_connect()

    # Give extra time on watcher startup for minions to report in to avoid
    # marking minions as down if the watcher has been down for a while.
    last_update_t = datetime.now() + timedelta(seconds=UPDATE_INTERVAL)

    print "listening for events"
    up_count = 0
    while True:
        event = listener.get_event(wait=UPDATE_INTERVAL/2, full=True)
        minion_id, ts = process_event(event)
        if minion_id:
            up_count += 1 
            write_presence(influx, minion_id, True, ts)

        now = datetime.now()
        if now - last_update_t > timedelta(seconds=UPDATE_INTERVAL):
            print "{} up events received".format(up_count)
            process_down_minions(influx)
            last_update_t = now


def process_event(event):
    if event is None:
        return None, None

    tag = event.get('tag', '')
    data = event.get('data', {})

    if tag == 'salt/event/exit':
        sys.exit()
    elif tag in ('salt/auth', 'minion_ping'):
        return data.get('id'), parse_stamp(data.get('_stamp'))
    return None, None


def parse_stamp(s):
    return datetime.strptime(s, "%Y-%m-%dT%H:%M:%S.%f")

    
def influx_connect():
    client = InfluxDBClient('localhost', 8086, database='device-status')
    client.create_database('device-status')
    return client


def write_presence(client, minion_id, up, stamp=None):
    if stamp is None:
        stamp = datetime.utcnow()
    client.write_points([{
        "measurement": "presence",
        "time": stamp,
        "tags": {"device": minion_id},
        "fields": {"up": up},
        }])


def process_down_minions(client):
    threshold_t = datetime.now() - timedelta(seconds=PRESENCE_INTERVAL)
    threshold_epoch = time.mktime(threshold_t.timetuple())

    results = client.query(
        "select device, last(up) as up from presence group by device",
        epoch='s')
    for r in results.get_points():
        # A "down" event is written event for devices which are already marked
        # as down so that Grafana will still see them even when displaying a
        # small time range.
        if r['time'] < threshold_epoch:
            write_presence(client, r['device'], False)


if __name__ == '__main__':
    main()
