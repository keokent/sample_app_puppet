class rbenv::install {
  package {
    [
      'gcc',
      'gcc-c++',
      'make',
      'openssl',
      'openssl-devel',
      'libxml2-devel',
      'libxslt-devel',
    ]:
    ensure => installed,
  }

  Exec { 
    path => '/usr/bin:/bin:/usr/local/bin:/usr/local/rbenv/bin',
  }

  exec { 'rbenv':   
    cwd => '/usr/local',
    user => 'root',
    command => 'git clone git://github.com/sstephenson/rbenv.git;chgrp -R appuser rbenv;chmod -R g+rwxXs rbenv;mkdir /usr/local/rbenv/plugins',
    creates => '/usr/local/rbenv',  
  }
}
