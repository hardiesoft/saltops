/boot/config.txt:
   file.managed:
     - source: salt://pi/config.txt

/etc/modules:
   file.managed:
     - source: salt://pi/modules

prevent-root-ssh-login:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: "PermitRootLogin no" 

/etc/rsyslog.conf:
   file.managed:
     - source: salt://pi/rsyslog.conf
