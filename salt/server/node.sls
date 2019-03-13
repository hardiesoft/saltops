node:
  pkgrepo.managed:
    - humanname: NodeJS
    - name: deb https://deb.nodesource.com/node_8.x/ bionic main
    - file: /etc/apt/sources.list.d/nodesource.list
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - clean_file: True
    - refresh: False
node.packages:
  pkg.installed:
    - pkgs:
      - node-gyp
      - nodejs
