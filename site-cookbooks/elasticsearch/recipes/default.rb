#
# Cookbook Name:: elasticsearch
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

cookbook_file '/etc/yum.repos.d/elasticsearch.repo' do
  source "elasticsearch.repo"
end

package 'elasticsearch' do
  action :install
  not_if "which elasticsearch"
end
