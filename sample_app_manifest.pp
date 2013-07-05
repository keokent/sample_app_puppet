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
    'git',
    'monit',
    'memcached',
  ]:
  ensure => installed,
}

user { 'appuser':
  ensure => present,
  uid => 1000,
  gid => 'appuser',
  comment => 'appuser',
  home => '/home/appuser',
  managehome => true,
  shell => '/bin/bash',
  require => Group['appuser'],
}

file { '/home/appuser':
  ensure => directory,
  owner => 'appuser',
  group => 'appuser',
  mode => '0755',
  require => User['appuser'],
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

file { '/etc/my.conf':,
  content => "character-set-server = utf8",
}

service { 'mysqld':
  enable => true,
  ensure => running,
  hasrestart => true,
  require => Package['mysql-server'],
}

Exec { 
  path => '/usr/bin:/bin:/usr/local/bin:/usr/local/rbenv/bin',
}

exec { 'rbenv':
  cwd => '/usr/local',
  user => 'root',
  command => 'git clone git://github.com/sstephenson/rbenv.git;chgrp -R appuser rbenv;chmod -R g+rwxXs rbenv;mkdir /usr/local/rbenv/plugins',
  creates => '/usr/local/rbenv',  
  require => Package['git'],
}

exec { 'path-rbenv':
  command => "echo 'export RBENV_ROOT=\"/usr/local/rbenv\"' >> /etc/profile.d/rbenv.sh;
  	      echo 'export PATH=\"/usr/local/rbenv/bin:\$PATH\"' >> /etc/profile.d/rbenv.sh;
              echo 'eval \"$(rbenv init -)\"' >> /etc/profile.d/rbenv.sh",
  unless => 'test -f /etc/profile.d/rbenv.sh',
  require => Exec['rbenv'],
}

exec { 'ruby-build':
  cwd => '/usr/local/rbenv/plugins',
  user => 'root',
  command => 'git clone git://github.com/sstephenson/ruby-build.git;cd ruby-build;./install.sh;chgrp -R appuser ruby-build;chmod -R g+rwxs ruby-build',
  creates => '/usr/local/rbenv/plugins/ruby-build',
  require => Exec['rbenv'],
}

exec { 'ruby2.0.0p195-install':
  user => 'root',
  command => 'ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195',
  creates => '/usr/local/rbenv/versions/2.0.0-p195/bin',
  timeout => 0,
  require => Exec['ruby-build'],
}

exec { 'bundler-insatll':
  command => "sh -c 'source /etc/profile.d/rbenv.sh;gem install bundler;rbenv rehash'",
  require => Exec['ruby2.0.0p195-install'],
}

exec { 'use-ruby2.0.0p195':
  command => 'echo "2.0.0-p195" > /usr/local/rbenv/version',
  require => Exec['ruby2.0.0p195-install'],
}

exec { 'mysql-create-user':
  command => 'mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO keoken@localhost IDENTIFIED BY \'passwd\'"',
  unless => 'mysql -u root -e "select User from mysql.user where User = \'keoken\' and Host = \'localhost\'\G" | grep keoken',
}

exec { 'mysql-create-database':
  command => 'mysql -u root -e "CREATE DATABASE sample_app_production"',
  unless => 'mysql -u root -e "show databases" | grep sample_app_production',
}

file { '/etc/monit.conf':
  owner => 'root',
  group => 'root',
  mode => '0700',
  content => template('monit.conf'),
  require => Package['monit'],
  notify => Service['monit'],
}

file { '/etc/monit.d/unicorn.conf':
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => template('unicorn.conf'),
  require => Package['monit'],
  notify => Service['monit'],
}

file { '/etc/init.d/unicorn_sample_app':
  owner => 'root',
  group => 'root',
  mode => '0755',
  content => template('unicorn_sample_app'),
}

file { '/etc/sudoers':
  owner => 'root',
  group => 'root',
  mode => '0100',
  content => template('sudoers'),
}

service { 'monit':
  enable => true,
  ensure => running,
  hasrestart => true,
  require => Package['monit'],
}

file { '/home/appuser/.ssh':
  ensure => directory,
  owner => 'appuser',
  group => 'appuser',
  mode => '0700',
  require => User['appuser']
}

file { '/home/appuser/.ssh/authorized_keys': 
  ensure => present,
  owner => 'appuser',
  group => 'appuser',
  mode  => '0700',
  content => template('id_rsa.pub'),
}

service { 'memcached':
  enable => true,
  ensure => running,
  hasrestart => true,
  require => Package['memcached'],
}

