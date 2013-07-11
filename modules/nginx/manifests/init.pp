class nginx {
  include nginx::install
  include nginx::service

     Class['nginx::install']
  -> Class['nginx::service']
}