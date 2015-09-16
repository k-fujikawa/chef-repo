#
# Cookbook Name:: caffe
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


software_dir = node['cuda']['software_dir']
local_user   = node['cuda']['local_user']
local_group  = node['cuda']['local_group']
has_gpu      = node['cuda']['gpu'] || true

directory software_dir do
  owner local_user
  group local_group
end

directory "#{software_dir}/cuda" do
  owner local_user
  group local_group
  action :create
end

# install cuda
if has_gpu
  remote_file "#{software_dir}/cuda/cuda-repo-ubuntu1404_7.5-18_amd64.deb" do
    source "http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb"
    action :create_if_missing
    notifies :run, 'bash[install-cuda-repo]', :immediately
    owner local_user
    group local_group
  end
  bash 'install-cuda-repo' do
    action :nothing
    code "dpkg -i #{software_dir}/cuda/cuda-repo-ubuntu1404_7.0-28_amd64.deb"
    notifies :run, 'execute[apt-get update]', :immediately
  end
  # https://bugs.launchpad.net/ubuntu/+source/nvidia-graphics-drivers-331/+bug/1401390
  # package 'cuda'
  execute 'install-cuda' do
    command "apt-get -q -y install --no-install-recommends cuda"
  end
end

# cudnn_filename = "#{node['caffe']['cudnn_tarball_name_wo_tgz']}.tgz"
# if File.exists? "#{File.dirname(__FILE__)}/../files/default/cudnn-tarball/#{cudnn_filename}"
#   cookbook_file "#{software_dir}/cuda/#{cudnn_filename}" do
#     source "cudnn-tarball/#{cudnn_filename}"
#     mode 0644
#     owner local_user
#     group local_group
#   end
#   execute "tar -zxf #{cudnn_filename}" do
#     cwd "#{software_dir}/cuda"
#     not_if { FileTest.exists? "#{software_dir}/cuda/#{node['caffe']['cudnn_tarball_name_wo_tgz']}" }
#     user local_user
#     group local_group
#   end
#   execute 'cp cudnn.h /usr/local/include' do
#     cwd "#{software_dir}/cuda/#{node['caffe']['cudnn_tarball_name_wo_tgz']}"
#     not_if { FileTest.exists? "/usr/local/include/cudnn.h" }
#   end
#   [ 'libcudnn_static.a', 'libcudnn.so.6.5.48' ].each do |lib|
#     execute "cp #{lib} /usr/local/lib" do
#     cwd "#{software_dir}/cuda/#{node['caffe']['cudnn_tarball_name_wo_tgz']}"
#       not_if { FileTest.exists? "/usr/local/lib/#{lib}" }
#     end
#   end
#   link "/usr/local/lib/libcudnn.so.6.5" do
#     to "/usr/local/lib/libcudnn.so.6.5.48"
#   end
#   link "/usr/local/lib/libcudnn.so" do
#     to "/usr/local/lib/libcudnn.so.6.5"
#   end
#   cudnn_installed = true
# end

cudnn_installed = false
# set up LD_LIBRARY_PATH
file "/etc/ld.so.conf.d/caffe.conf" do
  owner local_user
  group local_group
  content "/usr/local/cuda/targets/x86_64-linux/lib"
  notifies :run, 'execute[ldconfig]', :immediately
end
execute 'ldconfig' do
  action :nothing
end
git "#{software_dir}/caffe" do
  repository "https://github.com/BVLC/caffe.git"
  revision "e8dee350ade66a712144aebc8b5f4a8c989d43c0" # master as of Dec 13, 2014
  action :sync
  user local_user
  group local_group
end
template "#{software_dir}/caffe/Makefile.config" do
  source "Makefile.config.erb"
  mode 0644
  owner local_user
  group local_group
  variables({
      :cudnn_installed => cudnn_installed
  })
end


# install python requirements
execute 'install-python-reqs' do
  cwd "#{software_dir}/caffe/python"
  command <<-EOC
    export PYENV_ROOT="#{node['pyenv']['software_dir']}"
    export PATH="#{node['pyenv']['software_dir']}/bin:$PATH"
    eval "$(pyenv init -)" 
    (for req in $(cat requirements.txt); do pip install $req; done)
    pip install awscli
    pip install boto
  EOC
end

execute 'build-caffe' do
  cwd "#{software_dir}/caffe"
  command "make all -j8"
  creates "#{software_dir}/caffe/build"
  user local_user
  group local_group
  notifies :run, 'execute[build-caffe-tests]', :immediately
end
execute 'build-caffe-tests' do
  cwd "#{software_dir}/caffe"
  command "make test -j8"
  # action :nothing
  user local_user
  group local_group
  notifies :run, 'execute[build-caffe-python]', :immediately
end
execute 'build-caffe-python' do
  cwd "#{software_dir}/caffe"
  command "make pycaffe"
  # action :nothing
  user local_user
  group local_group
end

# fix warning message 'libdc1394 error: Failed to initialize libdc1394' when running make runtest
# http://stackoverflow.com/a/26028597
# need to set this on each boot since the /dev links are cleared after shutdown
#
# execute 'ln -s /dev/null /dev/raw1394' do
#   not_if { FileTest.exists? "/dev/raw1394" }
# end
# set path
# magic_shell_environment 'PATH' do
#   value "$PATH:#{software_dir}/caffe/build/tools"
# end
# magic_shell_environment 'PYTHONPATH' do
#   value "$PYTHONPATH:#{software_dir}/caffe/python"
# end

