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
    enusure => installed,
  }

  exec { 'rbenv':
    cwd => '/usr/local',
    user => 'root',
    command => 'git clone git://github.com/sstephenson/rbenv.git;chgrp -R appuser rbenv;chmod -R g+rwxXs rbenv;mkdir /usr/local/rbenv/plugins',
    creates => '/usr/local/rbenv',  
  }
}