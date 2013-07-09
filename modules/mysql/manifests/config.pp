class mysql::config {
  file { '/etc/my.conf':
    content => "character-set-server = utf8",
  }
}