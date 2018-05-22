
def pkg_installed_from_github(name, version, systemd_reload=True):
    """Install a deb pacakge from a Cacophony Project Github release if it
    isn't installed on the system already. Currently only ARM packages are
    installed.

    If a new version is installed, systemd will be asked to reload it's
    configuration so that any new service files in the package are known to
    systemd.
    """

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

