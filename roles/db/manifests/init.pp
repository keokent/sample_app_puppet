class db {
  include ::mysql
  include db::setup_mysql
  include db::config_mysql

     Class['::mysql::install']
  -> Class['db::config_mysql' ]
  ~> Class['::mysql::service']
  -> Class['db::setup_mysql']
}