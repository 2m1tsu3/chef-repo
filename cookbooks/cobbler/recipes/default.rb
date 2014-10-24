#
# Cookbook Name:: cobbler
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{epel-release cobbler cobbler-web dhcp httpd rsync fence-agents patch perl(Compress::Zlib) perl(Digest::MD5) perl(Digest::SHA) perl(LWP::UserAgent) perl(LockFile::Simple)}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "/tmp/debmirror-2.14-2.el6.noarch.rpm" do
  source "http://dl.fedoraproject.org/pub/epel/6/x86_64/debmirror-2.14-2.el6.noarch.rpm"
end

package "debmirror" do
  action :install
  source "/tmp/debmirror-2.14-2.el6.noarch.rpm"
  provider Chef::Provider::Package::Rpm
end

template "/etc/cobbler/dhcp.template" do
  source "dhcp.template.erb"
  mode "0644"
  owner "root"
  group "root"
end

template "/etc/cobbler/settings" do
  source "settings.erb"
  mode "0644"
  owner "root"
  group "root"
end

%w{dists arches}.each do |pattern|
  bash "conf_debmirror_#{pattern}" do
    code <<-EOL
    sed -ri "s/^@#{pattern}=/#@#{pattern}=/" /etc/debmirror.conf
    EOL
    only_if "cat /etc/debmirror.conf | grep '^@#{pattern}=' "
  end
end

bash "selinux_stop" do
  code <<-EOL
  setenforce 0
  EOL
  only_if "sestatus | grep 'Current mode' | grep enabled "
end

bash "selinux_disable" do
  code <<-EOL
  sed -r -i "s/^SELINUX=.*/SELINUX=disabled/" /etc/selinux/config 
  EOL
  not_if "grep '^SELINUX=disabled' /etc/selinux/config"
end

service "firewalld" do
  action [:disable, :stop]
end

bash "cobbler_conf" do
  code <<-EOL
  cobbler get-loaders
  cobbler sync
  EOL
end

%w{xinetd cobblerd httpd}.each do |srv|
  service srv do
    action [:enable, :start]
  end
end
