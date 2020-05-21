salt_pkgrepo:
  pkgrepo.managed:
    - humanname: SaltStack
    - name: deb https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main
    - file: /etc/apt/sources.list.d/saltstack.list
    - clean_file: True
    - refresh: False

