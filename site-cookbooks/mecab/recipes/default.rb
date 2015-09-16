#
# Cookbook Name:: mecab
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
groonga_release = "groonga-release-1.1.0-1.noarch.rpm"

remote_file "/tmp/#{groonga_release}" do
  source "http://packages.groonga.org/centos/#{groonga_release}"
end

rpm_package groonga_release do
  source "/tmp/#{groonga_release}"
  action :install
end

%w{
  groonga-libs
  groonga-devel
  groonga-normalizer-mysql
  groonga-normalizer-mysql-devel
  gperf
  ncurses-devel
  time
  zlib-devel
  groonga-tokenizer-mecab
  mecab
  mecab-devel 
  mecab-ipadic
}.each do |pack|
  package pack do
    action :install
    options '--enablerepo=epel,base'
  end
end

mecab_release = "mecab-python-0.996.tar.gz"
mecab_src     = "/tmp/#{mecab_release}"

remote_file mecab_src do
  source "http://mecab.googlecode.com/files/#{mecab_release}"
end

bash "pip" do
  user node['user']['name']
  group node['user']['group']
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    pip install #{mecab_src}
  EOC
end

