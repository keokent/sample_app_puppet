class ruby-build::rbenv {
  exec { 'path-rbenv':
    command => "echo 'export RBENV_ROOT=\"/usr/local/rbenv\"' >> /etc/profile.d/rbenv.sh;
    	        echo 'export PATH=\"/usr/local/rbenv/bin:\$PATH\"' >> /etc/profile.d/rbenv.sh;
                echo 'eval \"$(rbenv init -)\"' >> /etc/profile.d/rbenv.sh",
    unless => 'test -f /etc/profile.d/rbenv.sh',
    require => Exec['rbenv'],
  }

  exec { 'ruby-build':
    cwd => '/usr/local/rbenv/plugins',
    user => 'root',
    command => 'git clone git://github.com/sstephenson/ruby-build.git;cd ruby-build;./install.sh;chgrp -R appuser ruby-build;chmod -R g+rwxs ruby-build',
    creates => '/usr/local/rbenv/plugins/ruby-build',
    require => Exec['rbenv'],
  }

  exec { 'ruby2.0.0p195-install':
    user => 'root',
    command => 'ruby-build 2.0.0-p195 /usr/local/rbenv/versions/2.0.0-p195',
    creates => '/usr/local/rbenv/versions/2.0.0-p195/bin',
    timeout => 0,
    require => Exec['ruby-build'],
  }

  exec { 'bundler-insatll':
    command => "sh -c 'source /etc/profile.d/rbenv.sh;gem install bundler;rbenv rehash'",
    require => Exec['ruby2.0.0p195-install'],
  }

  exec { 'use-ruby2.0.0p195':
    command => 'echo "2.0.0-p195" > /usr/local/rbenv/version',
    require => Exec['ruby2.0.0p195-install'],
  }
}
