########################################################
# Ensure that modemd is installed, configured & running
########################################################

modemd-pkg:
  fever.pkg_installed_from_github:
    - name: modemd
    - version: "1.1.1"
    - cacophony_project: True


modemd:
  service.running:
    - enable: True
    - watch:
      - modemd-pkg
