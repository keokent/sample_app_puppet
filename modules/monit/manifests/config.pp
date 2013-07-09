class monit::config {
  file { '/etc/monit.conf':
    owner => 'root',
    group => 'root',
    mode => '0700',
    content => template('monit.conf'),
  }

  file { '/etc/monit.d/unicorn.conf':
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('unicorn.conf'),
  }
}
