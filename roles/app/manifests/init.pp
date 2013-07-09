class app {
  include ::nginx
  include ::rbenv
  include ::monit
  include ::memcached
  include app::user
  include app::unicorn
  include app::common::path

     Class['app::user']
  -> Class['app::common::path']
  -> Class['::nginx']
  -> Class['::rbenv']
  -> Class['app::unicorn']
  -> Class['::monit']
  -> Class['::memcached']
}
