#
# Cookbook Name:: peco
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "install-peco" do
  not_if 'which peco'
  code <<-EOC
    cd /tmp
    wget https://github.com/peco/peco/releases/download/v0.2.9/peco_linux_amd64.tar.gz
    tar -xzf peco_linux_amd64.tar.gz
    mv peco_linux_amd64/peco /usr/local/bin/
  EOC
end
