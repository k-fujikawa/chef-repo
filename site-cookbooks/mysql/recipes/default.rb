#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

my_cnf_path  = '/etc/my.cnf'

bash 'remove_installed_mysql' do
  only_if 'yum list installed | grep mysql*'
  user 'root'

  code <<-EOL
    yum remove -y mysql*
  EOL
end

remote_file "/tmp/#{node['mysql']['file_name']}" do
  source "#{node['mysql']['remote_uri']}"
end

bash "install_mysql" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar xf "#{node['mysql']['file_name']}"
  EOH
end

node['mysql']['package_name'].each do |package_name|
  package package_name do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{package_name}-#{node['mysql']['full_version']}.rpm"
  end
end

template "#{my_cnf_path}" do
  user 'root'
  group 'root'
  mode '0644'
  source 'my.cnf.erb'

  variables ({
    :server_charset                  => node['mysql']['server_charset'],
    :max_connections                 => node['mysql']['max_connections'],
    :query_cache_size                => node['mysql']['query_cache_size'],
    :table_cache_size                => node['mysql']['table_cache_size'],
    :thread_cache_size               => node['mysql']['thread_cache_size'],
    :join_buffer_size                => node['mysql']['join_buffer_size'],
    :sort_buffer_size                => node['mysql']['sort_buffer_size'],
    :read_rnd_buffer_size            => node['mysql']['read_rnd_buffer_size'],
    :innodb_file_per_table           => node['mysql']['innodb_file_per_table'],
    :innodb_data_file_path           => node['mysql']['innodb_data_file_path'],
    :innodb_autoextend_increment     => node['mysql']['innodb_autoextend_increment'],
    :innodb_buffer_pool_size         => node['mysql']['innodb_buffer_pool_size'],
    :innodb_additional_mem_pool_size => node['mysql']['innodb_additional_mem_pool_size'],
    :innodb_write_io_threads         => node['mysql']['innodb_write_io_threads'],
    :innodb_read_io_threads          => node['mysql']['innodb_read_io_threads'],
    :innodb_log_buffer_size          => node['mysql']['innodb_log_buffer_size'],
    :innodb_log_file_size            => node['mysql']['innodb_log_file_size'],
    :innodb_flush_log_at_trx_commit  => node['mysql']['innodb_flush_log_at_trx_commit']
  })
end

service 'mysql' do
  action [:start, :enable]
end

# version 5.6 over
if node["mysql"]["version"].to_f >= 5.6
  package 'expect' do
    only_if 'ls /root/.mysql_secret'
    :install
  end

  cookbook_file '/tmp/password_set' do
    user "root"
    only_if 'ls /root/.mysql_secret'
    source "password_set"
  end

  execute 'password_set' do
    user 'root'
    only_if 'ls /root/.mysql_secret'
    # command 'chmod +x /tmp/password_set && /tmp/password_set && rm -f /tmp/password_set'
    command 'chmod +x /tmp/password_set && /tmp/password_set'
  end

  package 'expect' do
    :remove
  end
end
