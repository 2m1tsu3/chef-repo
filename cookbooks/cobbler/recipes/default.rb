#
# Cookbook Name:: cobbler
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "rpm_cobbler" do
  user "root"
  code <<-EOS
  rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
  EOS
end

package "cobbler" do
  action :install
end

%w{cobbler dhcpd httpd xinetd}.each do |pkg|
  service pkg do
    action [:enable, :start]
  end
end
