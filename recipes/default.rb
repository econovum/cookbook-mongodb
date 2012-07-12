# encoding: utf-8

case node[:platform]
when "redhat", "centos", "fedora"
  template "/etc/yum.repos.d/10gen.repo"

  execute "yum -y update"
  execute "yum -y install mongo-10gen mongo-10gen-server"
when "debian", "ubuntu"
  include_recipe "apt"

  apt_repository "10gen" do
    action :add
    init_process = node[:platform] == "debian" || node[:lsb][:codename] <= "karmic" ? "debian-sysvinit" : "ubuntu-upstart"
    uri "http://downloads-distro.mongodb.org/repo/#{init_process} "
    distribution "dist"
    components %w(10gen)
    keyserver "keyserver.ubuntu.com"
    key "7F0CEB10"
  end

  package "mongodb-10gen" do
    action :install
  end
else
  raise "Platform #{node[:platform]} is not supported yet!"
end
