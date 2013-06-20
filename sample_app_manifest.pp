package { 
  [
    'zsh',
    'emacs',
    'nginx',
    'mysql-server',
    'mysql-devel',
    'gcc',
    'gcc-c++',
    'make',
    'openssl',
    'openssl-devel',
    'libxml2-devel',
    'libxslt-devel',
  ]:
  ensure => installed,
}

user { 'appuser':
  ensure => present,
  uid => 1000,
  gid => appuser,
  comment => 'appuser',
  home => '/home/appuser',
  managehome => ture,
  shell => '/bin/bash'
}

group { 'appuser':
  ensure => present,
  gid => 1000,
}