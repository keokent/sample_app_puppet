class app {
  include ::nginx
  include ::rbenv
  include ::monit
  include ::memcached
  include app::user
  include app::unicorn
  include app::nginx::config

     Class['app::user']
  -> Class['::nginx::install']
  -> Class['app::nginx::config']
  ~> Class['::nginx::service']
  -> Class['::rbenv']
  -> Class['app::unicorn']
  -> Class['::monit']
  -> Class['::memcached']
}
