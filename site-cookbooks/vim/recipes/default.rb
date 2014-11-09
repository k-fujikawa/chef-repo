#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git node['user']['home'] + '/dotfiles/.vim/bundle/neobundle' do
  user node['user']['name']
  group node['user']['group']
  repository "https://github.com/Shougo/neobundle.vim"
  reference "master"
  # action :sync
  action :checkout
end

bash "neobundle install" do
  code <<-EOC
    vim +":NeoBundleInstall" +:q
  EOC
end
