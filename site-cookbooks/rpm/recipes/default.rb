#
# Cookbook Name:: rpm
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{
gcc
gcc-c++
git
make
wget
tree
java-1.8.0-openjdk-devel.x86_64
atlas-sse3-devel
gcc-gfortran
bzip2-devel

readline-devel
openssl-devel
libffi-devel

vim-enhanced
tmux
zsh
}.each do |pkg|
  package pkg do
    action :install
    not_if "which #{pkg}"
    options '--enablerepo=epel,base'
  end
end

# remote_file "/tmp/#{node['java']['file_name']}" do
#   source "#{node['mysql']['remote_uri']}"
# end
# package "#{node['mysql']['']}"
