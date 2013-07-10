class db::setup_mysql {
  exec { 'mysql-create-user':
    path => '/usr/bin:/bin',
    command => 'mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO keoken@\'192.168.48.%\' IDENTIFIED BY \'passwd\'"',
    unless => 'mysql -u root -e "select User from mysql.user where User = \'keoken\' and Host = \'192.168.48.%\'\G" | grep keoken',
  }

  exec { 'mysql-create-database':
    path => '/usr/bin:/bin',
    command => 'mysql -u root -e "CREATE DATABASE sample_app_production"',
    unless => 'mysql -u root -e "show databases" | grep sample_app_production',
  }
}
