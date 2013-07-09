class app {
  include ::nginx
  include ::rbenv
  include ::monit
  include ::memcached
  include app::common::path

     Class['app::user']
  -> Class['app::comon::path']
  -> Class['::nginx']
  -> Class['::rbenv']
  -> Class['app::unicorn']
  -> Class['::monit']
  -> Class['::memcached']
}
