class db::config_mysql {
  file { '/etc/my.cnf':
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template['db/my.cnf'],
  }
}