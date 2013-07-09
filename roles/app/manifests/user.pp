class app::user {
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

  file { '/etc/sudoers':
    owner => 'root',
    group => 'root',
    mode => '0440',
    content => template('/app/sudoers'),
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
    content => template('app/id_rsa.pub'),
  }
}
