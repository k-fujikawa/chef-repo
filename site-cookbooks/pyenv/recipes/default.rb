#
# Cookbook Name:: pyenv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

software_dir = node['pyenv']['software_dir']
local_user   = node['pyenv']['local_user']
local_group  = node['pyenv']['local_group']
profile_path = local_user == 'root' ? '/etc/profile' : '~/.bashrc'

directory software_dir do
  owner local_user
  group local_group
end

git node['pyenv']['software_dir'] do
  user node['pyenv']['local_user']
  group node['pyenv']['local_group']
  repository "git://github.com/yyuu/pyenv.git"
  reference "master"
  action :checkout
end

bash "pyenv" do
  user node['pyenv']['local_user']
  group node['pyenv']['local_group']
  cwd "#{software_dir}/plugins/python-build"

  code <<-EOC
    export PYENV_ROOT="#{software_dir}"
    export PATH="#{software_dir}/bin:$PATH"
    ./install.sh
    eval "$(pyenv init -)"
    CONFIGURE_OPTS="--enable-shared --enable-unicode=ucs4" pyenv install #{node['pyenv']['version']}
    pyenv global #{node['pyenv']['version']}
  EOC

  not_if { File.exists?("#{software_dir}/shims/python") }
end

