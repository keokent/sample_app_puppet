require 'spec_helper'

describe group('appuser') do
  it { should exist }
  it { should have_gid 1000 }
end

describe user('appuser') do
  it { should exist }
  it { should have_uid 1000 }
  it { should belong_to_group 'appuser' }
  it { should have_home_directory '/home/appuser' }
end

describe file('/home/appuser') do
  it { should be_mode 755 }
end

describe file('/home/appuser/sample_app/tmp/sockets/.unicorn.sock') do
  it { should be_socket }
end

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe file('/etc/nginx/nginx.conf') do
  it { should contain 'user nginx nginx;' }
  it { should contain 'server unix:/home/appuser/sample_app/tmp/sockets/.unicorn.sock fail_timeout=0;' }
  it { should contain('root /home/appuser/sample_app/public;').from(/^\s+server {/).to(/^\s+location @app/) }
end

describe package('mysql-server') do
  it { should be_installed }
end

describe service('mysqld') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

describe file('/usr/local/rbenv/versions/2.0.0-p195/bin') do
  it { should be_directory }
end




