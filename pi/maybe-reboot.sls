reboot_after_boot_changes:
  module.run:
    - name: system.reboot
    - at_time: 1
    - onchanges:
      - /boot/config.txt
      - /boot/cmdline.txt
      - /etc/modules
      - /etc/salt/pki/minion/minion_master.pub

reboot_for_config_import:
  module.run:
    - name: system.reboot
    - at_time: 1
    - unless: test -f /etc/cacophony/config.toml
