class mysql::install {
  package {
    [
      'mysql-server',
      'mysql-devel',
    ]:
    ensure => installed,
  }
}