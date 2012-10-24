# encoding: utf-8
package 'cronie' do
  action :install
end

execute 'mongo --eval "rs.initiate()"' do
  action :nothing
end

case node['platform']
when "redhat", "centos", "fedora", "amazon", "scientific"
  template "/etc/yum.repos.d/10gen.repo"

  package "mongo-10gen" do
    action :install
  end

  package "mongo-10gen-server" do
    action :install
  end

  service "mongod" do
    action [:enable, :start]
    notifies :run, 'execute[mongo --eval "rs.initiate()"]', :delayed
  end
when "debian", "ubuntu"
  include_recipe "apt"

  apt_repository "10gen" do
    action :add
    init_process = node['platform'] == "debian" || node['lsb']['codename'] <= "karmic" ? "debian-sysvinit" : "ubuntu-upstart"
    uri "http://downloads-distro.mongodb.org/repo/#{init_process} "
    distribution "dist"
    components %w(10gen)
    keyserver "keyserver.ubuntu.com"
    key "7F0CEB10"
  end

  package "mongodb-10gen" do
    action :install
  end

  service "mongod" do
    action [:enable, :start]
  end
else
  raise "Platform #{node['platform']} is not supported yet!"
end

template "/etc/mongod.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[mongod]", :delayed
end

service "crond" do
  action :nothing
end

template "/etc/cron.daily/mongodb-backup.cron" do
  owner "root"
  group "root"
  mode 0755
  notifies :restart, "service[crond]"
end

