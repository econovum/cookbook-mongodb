# encoding: utf-8
port = node['mongodb']['port']

#define resource that initiates our replica set
execute 'mongo-initiate-replicaset' do
  #run this command
  command "mongo 127.0.0.1:#{port} --eval \"rs.initiate()\""
  #do not execute upon definition, only when notified
  action :nothing
end

case node['platform']
when "redhat", "centos", "fedora", "amazon", "scientific"
  template "/etc/yum.repos.d/10gen.repo"

  %w{cronie mongo-10gen mongo-10gen-server}.each do |pkg|
    package pkg do
      action :install
    end
  end

  template "/var/lib/mongo/keyfile" do
    owner "mongod"
    group "mongod"
    mode 0400
    notifies :restart, "service[mongod]"
  end

  template "/etc/mongod.conf" do
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[mongod]"
    notifies :run, resources(:execute => "mongo-initiate-replicaset")
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

  service "mongod" do
    action [:enable, :start]
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

  service "mongodb" do
    action [:enable, :start]
  end
else
  raise "Platform #{node['platform']} is not supported yet!"
end

