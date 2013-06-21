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

service { 'nginx':
  enable => true,
  ensure => running,
  hasrestart => true,
  require =>Package['nginx'],
}

file { '/etc/nginx/nginx.conf':
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => template('nginx.conf'),
  require => Package['nginx'],
  notify => Service['nginx'],
}

file { '/etc/my.conf':
  content => "character-set-server = utf8",
}

service { 'mysqld':
  enable => true,
  ensure => running,
  hasrestart => true,
  require => Package['mysql-server'],
}
