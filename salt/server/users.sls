{% for user, ssh_key in pillar.get('users', {}).items() %}
{{user}}:
  user.present:
    - shell: /bin/bash
    - groups:
      - sudo
      - adm

{{user}}-keys:
  ssh_auth.present:
    - user: {{user}}
    - name: "{{ssh_key}}"
{% endfor %}
