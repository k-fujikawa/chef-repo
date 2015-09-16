#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git node['user']['home'] + "/.rbenv" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
end

directory "#{node['user']['home']}/.rbenv/plugins/" do
  user node['user']['name']
  group node['user']['group']
  action :create
end

git "#{node['user']['home']}/.rbenv/plugins/ruby-build/" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :checkout
end

bash "rbenv" do
  user node['user']['name']
  group node['user']['group']
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
    rbenv install #{node['rbenv']['version']}
    rbenv global #{node['rbenv']['version']}
    rbenv versions
    rbenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.rbenv/shims/ruby") }
end

