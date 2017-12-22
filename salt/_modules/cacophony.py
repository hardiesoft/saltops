import gzip
import shutil
import tempfile
import urllib2
import os
from os import path


def upgrade():
    return [
        upgrade_recorder(), 
        upgrade_uploader(),
    ]


def upgrade_recorder():
    return _upgrade(
        "thermal-recorder",
        "https://github.com/TheCacophonyProject/thermal-recorder/releases/download/{}/thermal-recorder.gz",
        __pillar__['thermal-recorder-version'],
    )


def upgrade_uploader():
    return _upgrade(
        "thermal-uploader",
        "https://github.com/TheCacophonyProject/thermal-uploader/releases/download/{}/thermal-uploader.gz",
        __pillar__['thermal-uploader-version'],
    )


def _upgrade(name, url_pattern, version):
    url = url_pattern.format(version)

    temp_dir = tempfile.mkdtemp()
    try:
        download_filename = path.join(temp_dir, path.basename(url))
        with open(download_filename, "wb") as f:        
            r = urllib2.urlopen(url)
            shutil.copyfileobj(r, f)

        uncompressed_filename = path.join(temp_dir, name)

        with open(uncompressed_filename, "wb") as f:
            g = gzip.GzipFile(download_filename)
            shutil.copyfileobj(g, f)

        dest_filename = path.join("/usr/local/bin", name)
        __salt__['service.stop'](name)
        try:
            shutil.copy(uncompressed_filename, dest_filename)
            os.chmod(dest_filename, 0755)
        finally:
            __salt__['service.start'](name)
    finally:
        shutil.rmtree(temp_dir)

    return "{} upgraded to {}".format(name, version)
