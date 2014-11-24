#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git "/tmp/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "install-rubybuild" do
  not_if 'which ruby-build'
  code <<-EOC
    cd /tmp/ruby-build
    ./install.sh
  EOC
end

git node['user']['home'] + "/.rbenv" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  # action :sync
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
    rbenv local #{node['rbenv']['version']}
    rbenv versions
    rbenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.rbenv/shims/ruby") }
end

# bash "gem" do
#   user node['user']['name']
#   group node['user']['group']
#   cwd node['user']['home']
#   environment "HOME" => node['user']['home']
#
#   code <<-EOC
#     gem install bundle
#     gem install rake
#   EOC
# end
#
