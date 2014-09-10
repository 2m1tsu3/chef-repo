#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node[:platform]

when "ubuntu","debian"

    package "apache2" do
        action :install
    end

    service "apache2" do
        action [ :enable, :start ]
    end

when "centos","fedora"

    package "httpd" do
        action :install
    end

    service "httpd" do
        action [ :enable, :start ]
    end

end

