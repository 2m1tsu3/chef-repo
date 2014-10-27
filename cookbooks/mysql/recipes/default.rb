#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "mysql-server" do
    action :install
end

case node[:platform]

when "ubuntu","debian"
    service "mysql" do
        action [ :enable, :start ]
    end

when "centos","fedora"
    service "mysqld" do
        action [ :enable, :start ]
    end

end
