class proxy {
  include ::nginx
  include proxy::nginx::config

     Class['::nginx::install']
  -> Class['proxy::nginx::config']
  ~> Class['::nginx::service']
}
