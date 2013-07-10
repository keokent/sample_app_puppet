class app {
  include ::nginx
  include ::rbenv
  include ::monit
  include ::memcached
  include app::user
  include app::unicorn

     Class['app::user']
  -> Class['::nginx']
  -> Class['::rbenv']
  -> Class['app::unicorn']
  -> Class['::monit']
  -> Class['::memcached']
}
