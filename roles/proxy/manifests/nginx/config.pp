class proxy::nginx::config {
  file { '/etc/nginx/nginx.conf':
   owner => 'root',
   group => 'root',
   mode => '0644',
   content => template('proxy/nginx/nginx.conf'),
  }

  file { '/etc/nginx/conf.d/proxy.conf':
   owner => 'root',
   group => 'root',
   mode => '0644',
   content => template('proxy/nginx/proxy.conf'),
  }
}