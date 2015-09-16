#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "sshconfig setting" do
  not_if { File.exists?(node['user']['home'] + '/.ssh/config') }
  path node['user']['home'] + '/.ssh/config'
  source "ssh_config"
  user node['user']['name']
  group node['user']['group']
  mode 0600
end

git node['user']['home'] + '/dotfiles' do
  user node['user']['name']
  group node['user']['group']
  repository "git@github.com:k-fujikawa/dotfiles.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "setup" do
  user node['user']['name']
  cwd node['user']['home'] + '/dotfiles'
  environment ({'HOME' => node['user']['home']})
  code <<-EOH
    bash setup.sh
  EOH
end

package "zsh"
# execute 'set zsh as default shell' do
#   command "chsh -s /bin/zsh #{node['user']['name']}"
# end
