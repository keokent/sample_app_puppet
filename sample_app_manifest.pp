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
  path => '/usr/bin:/bin:/usr/local/bin',
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

#exec { 'use-rbenv-command':
#  command => 'sh -c "source /etc/profile.d/rbenv.sh"',
#  require => Exec['path-rbenv'],
#}

exec { 'ruby-build':
  cwd => '/usr/local/rbenv/plugins',
  user => 'root',
  command => 'git clone git://github.com/sstephenson/ruby-build.git;cd ruby-build;./install.sh;chgrp -R appuser ruby-build;chmod -R g+rwxs ruby-build',
  creates => '/usr/local/rbenv/plugins/ruby-build',
  require => Exec['rbenv'],
}

exec { 'ruby-2.0.0p195-make-directory':
  cwd => '/usr/local/rbenv',
  user => 'root',
  command => 'mkdir -p /usr/local/rbenv/versions/2.0.0-p195',
  creates => '/usr/local/rbenv/versions/2.0.0-p195',
  require => Exec[rbenv],
}

exec { 'ruby2.0.0p195-install':
  cwd => '/usr/local/rbenv/versions/2.0.0-p195',
  user => 'root',
  command => 'ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195',
  creates => '/usr/local/rbenv/versions/2.0.0-p195/bin',
  timeout => 0,
  require => Exec['ruby-2.0.0p195-make-directory'],
}

exec { 'use-ruby2.0.0p195':
  command => 'echo "2.0.0-p195" > /usr/local/rbenv/version',
#  command => 'sh -c "source /etc/profile.d/rbenv.sh;rbenv global 2.0.0-p195"',
  require => Exec['ruby2.0.0p195-install'],
}

exec { 'mysql-create-user':
 command => 'mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO keoken@localhost IDENTIFIED BY \'passwd\'"',
 unless => 'mysql -u root -e "select User , Host from mysql.user where User = \'keoken\' and Host = \'localhost\'"',
}



