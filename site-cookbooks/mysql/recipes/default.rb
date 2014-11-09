#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash 'remove_installed_mysql' do
  only_if 'yum list installed | grep mysql*'
  user 'root'

  code <<-EOL
    yum remove -y mysql*
  EOL
end

remote_file "/tmp/#{node['mysql']['file_name']}" do
  source "#{node['mysql']['remote_uri']}"
end

bash "install_mysql" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar xf "#{node['mysql']['file_name']}"
  EOH
end

node['mysql']['rpm'].each do |rpm|
  package rpm['package_name'] do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{rpm['rpm_file']}"
  end
end