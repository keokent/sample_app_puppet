class app::unicorn {
  file { '/etc/init.d/unicorn_sample_app':
    owner => 'root',
    group => 'root',
    mode => '0755',
    content => template('app/unicorn_sample_app'),
  }
}
