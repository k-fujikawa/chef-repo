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
tig

readline-devel
openssl-devel

vim-enhanced
tmux
zsh
}.each do |pkg|
  package pkg do
    action :install
    not_if "which #{pkg}"
  end
end

