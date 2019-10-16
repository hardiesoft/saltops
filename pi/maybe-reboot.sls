system.reboot:
  module.run:
    - onchanges:
      # List things here that should trigger a reboot at the end of
      # state.apply if changed.
      - cacophony-config-pkg
