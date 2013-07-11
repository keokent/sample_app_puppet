class nginx::config {
  file { '/etc/nginx/nginx.conf':
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template('app/nginx/nginx.conf'),
  }
}
