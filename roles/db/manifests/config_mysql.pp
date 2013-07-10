class mysql::config {
  file { '/etc/my.cnf':
    owner => 'root',
    group => 'root',
    mode => '0644'
    content => template['my.cnf'],
  }
}