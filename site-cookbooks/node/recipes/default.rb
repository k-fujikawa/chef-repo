#
# Cookbook Name:: node
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git "#{node['user']['home']}/.ndenv" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/riywo/ndenv.git"
  reference "master"
  action :checkout
end

directory "#{node['user']['home']}/.ndenv/plugins/" do
  user node['user']['name']
  group node['user']['group']
  action :create
end

git "#{node['user']['home']}/.ndenv/plugins/node-build" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/riywo/node-build.git"
  reference "master"
  # action :sync
  action :checkout
end


bash "ndenv" do
  user node['user']['name']
  group node['user']['group']
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    export PATH="$HOME/.ndenv/bin:$PATH"
    eval "$(ndenv init -)"
    ndenv install #{node['ndenv']['version']}
    ndenv global #{node['ndenv']['version']}
    ndenv versions
    ndenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.ndenv/shims/node") }
end

