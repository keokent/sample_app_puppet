class db {
  include ::mysql
  include db::setup_mysql

     Class['::mysql']
  -> Class['db::setup_mysql']
}