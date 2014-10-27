#
# Cookbook Name:: bind
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node[:platform]

when "ubuntu","debian"
  %w{bind9 bind9utils}.each do |pkg|
    package pkg do
      action :install
    end
  end
    
  service "bind9" do
    action [:enable, :start]
  end

when "centos","fedora"
  %w{bind bind-utils}.each do |pkg|
    package pkg do
      action :install
    end
  end

  service "named" do
    action [:enable, :start]
  end

end
