import os
import subprocess


def pkg_installed_from_github(name, version, systemd_reload=True):
    """Install a deb pacakge from a Cacophony Project Github release if it
    isn't installed on the system already. Currently only ARM packages are
    installed.

    If a new version is installed, systemd will be asked to reload it's
    configuration so that any new service files in the package are known to
    systemd.
    """

    # Guard against versions being converted to floats in YAML parsing.
    assert isinstance(version, basestring), "version must be a string"

    installed_version = __salt__['pkg.version'](name)
    if installed_version == version:
        return {
            'name': name,
            'result': True,
            'comment': 'Version %s already installed.' % version,
            'changes': {}
        }

    source_url = 'https://github.com/TheCacophonyProject/{name}/releases/download/v{version}/{name}_{version}_arm.deb'.format(
        name=name,
        version=version,
    )   
    ret = __states__['pkg.installed'](
        name=name, 
        version=version, 
        sources=[{name: source_url}],
        refresh=False,
    )

    if systemd_reload and ret['result'] and ret['changes'] and not __opts__['test']:
        __salt__['cmd.run']('systemctl daemon-reload')
        ret['comment'] += ' (systemd reloaded)'

    return ret


def init_alsa(name):
    """Ensure that the built-in audio hardware is correctly initialised.
    """
    if _is_audio_setup():
        return {
            'name': name,
            'result': True,
            'comment': "Audio already set up",
            'changes': {}
        }

    _remove_if_present('/var/lib/alsa/asound.state')

    # Play something (silence) to ensure the audio hardware is initialised
    # within ALSA.
    if not _play_silence():
        return {
            'name': name,
            'result': True,
            'comment': "Playing audio failed (no audio hardware present?)",
            'changes': {}
        }

    # Save the ALSA state to disk.
    subprocess.check_call(['alsactl', 'store'])
    return {
        'name': name,
        'result': True,
        'comment': "ALSA state updated",
        'changes': {
            name: {
                'old': '', 
                'new': 'configured',
            },
        },
    }

    
def _is_audio_setup():
    output = subprocess.check_output("amixer")
    return "Simple mixer control 'PCM',0" in output


def _remove_if_present(name):
    try:
        os.remove(name)
    except OSError:
        pass


def _play_silence():
    "Play 100ms of silence and return True if this succeeeded"
    exit_code = subprocess.call("sox -n -t wav - trim 0.0 0.100 | play -q -", shell=True)
    return exit_code == 0

