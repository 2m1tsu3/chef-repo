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

%w{epel-release cobbler cobbler-web dhcpd}.each do |pkg|
  package pkg do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{rpm}"
  end
end

%w{xinetd cobblerd httpd}.each do |srv|
  service pkg do
    action [:enable, :start]
  end
end

bash "cobbler_conf" do
  code <<-EOL
  sed -r "s/(^allow_dynamic_settings: ).*/\11/" /etc/cobbler/settings
  cobbler setting edit --name server --value 192.168.100.4
  cobbler setting edit --name next_server --value 192.168.100.4
  cobbler setting edit --name manage_dhcp --value 1
  cobbler get-loaders
  EOL
end
