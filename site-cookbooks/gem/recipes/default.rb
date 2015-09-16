#
# Cookbook Name:: gem
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user node['user']['name']
group node['user']['group']

gem_package "bundler" do
  gem_binary node['user']['home'] + "/.rbenv/shims/gem"
  action :install
end

gem_package "pry" do
  gem_binary node['user']['home'] + "/.rbenv/shims/gem"
  action :install
end


