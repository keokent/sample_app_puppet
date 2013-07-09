class db {
  include ::mysql

     Class['::mysql']
  -> Class['db::setup_mysql']
}