mail-packages: 
  pkg.installed:
    - pkgs:
      - postfix
      - mailutils

/etc/mailname:
   file.managed:
     - contents: 
       - "{{ grains['fqdn'] }}"
     - template: jinja

/etc/postfix/main.cf:
   file.managed:
     - source: salt://server/mail-relay/main.cf
     - template: jinja

postfix-service:
  service.running:
   - name: postfix
   - enable: true
   - watch:
     - /etc/postfix/main.cf
     - /etc/mailname

/etc/aliases:
   file.managed:
     - source: salt://server/mail-relay/aliases
     - template: jinja

newaliases:
  cmd.run:
    - onchanges:
      - /etc/aliases
