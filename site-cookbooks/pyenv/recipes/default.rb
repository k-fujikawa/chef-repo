#
# Cookbook Name:: pyenv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{
atlas-sse3-devel
gcc-gfortran
bzip2-devel
}.each do |pkg|
  package pkg do
    action :install
    not_if "which #{pkg}"
  end
end

git node['user']['home'] + '/.pyenv' do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/yyuu/pyenv.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "pyenv" do
  user node['user']['name']
  group node['user']['group']
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv install #{node['pyenv']['version']}
    pyenv local #{node['pyenv']['version']}
    pyenv versions
    pyenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.pyenv/shims/python") }
end

# python_pip "numpy" do
#   action :install
# end
#
# python_pip "scipy" do
#   action :install
# end
#
# python_pip "gensim" do
#   action :install
# end
bash "pip" do
  user node['user']['name']
  group node['user']['group']
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    pip install numpy
    pip install scipy
    pip install gensim
  EOC
end
#
