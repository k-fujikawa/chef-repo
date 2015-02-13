#
# Cookbook Name:: gem
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


gem_package "bundler" do
  # not_if "which bundle"
  gem_binary node['user']['home'] + "/.rbenv/shims/gem"
  action :install
end

gem_package "pry" do
  # not_if "which pry"
  gem_binary node['user']['home'] + "/.rbenv/shims/gem"
  action :install
end


