yumrepo { 'nginx':
  describe => 'nginx yum repository',
  baseurl => 'http://nginx.org/packages/centos/6/$basearch/',
  enabled => 1,
  gpgcheck => 0,
}

package { 'nginx':
  ensure => installed,
  require => Yumrepo['nginx'],
}

$port = 80

