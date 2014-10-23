#
# Cookbook Name:: cobbler
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#rpm="epel-release-7-2.noarch.rpm"
#rpm_check="b96dda365bbab41b187b8f0cc657b6240f000e52404134d831d8432c443c9526"
#
#cookbook_file "/tmp/#{rpm}" do
#  source "#{rpm}"
#  checksum "#{rpm_check}"
#end 

%w{epel-release cobbler cobbler-web dhcp}.each do |pkg|
  package pkg do
    action :install
  end
end

%w{xinetd cobblerd httpd}.each do |srv|
  service srv do
    action [:enable, :start]
  end
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

bash "selinux_stop" do
  code <<-EOL
  setenforce 0
  EOL
  only_if "sestatus | grep 'Current mode' | grep enabled "
end

bash "selinux_disable" do
  code <<-EOL
  sed -r "s/(SELINUX=)enforcing/\1disabled/" /etc/selinux/config
  EOL
  only_if "sestatus | grep 'Mode from config file' | grep 'enforcing\|permissive' "
end

service "firewalld" do
  action [:disable, :stop]
end

bash "cobbler_conf" do
  code <<-EOL
  cobbler get-loaders
  EOL
end
