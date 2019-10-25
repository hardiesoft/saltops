reboot_after_boot_changes:
  module.run:
    - name: system.reboot
    - onchanges:
      - /boot/config.txt
      - /boot/cmdline.txt
      - /etc/modules

reboot_for_config_import:
  module.run:
    - name: system.reboot
    - unless: test -f /etc/cacophony/config.toml
