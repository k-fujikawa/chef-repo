#
# Cookbook Name:: ubuntu
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

execute 'apt-get update'
package "build-essential"
# linux headers
package "linux-headers-#{node['os_version']}"
# https://forums.aws.amazon.com/thread.jspa?messageID=558414
package "linux-image-#{node['os_version']}"
# http://stackoverflow.com/a/26525293
package "linux-image-extra-#{node['os_version']}"

%w{
  git zlibc libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm
  libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libatlas-base-dev 
  libhdf5-serial-dev libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler gfortran
}.each do |pkg|
  package pkg do
    action :install
  end
end


