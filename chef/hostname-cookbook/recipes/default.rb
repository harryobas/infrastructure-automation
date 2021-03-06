#
# Cookbook Name:: hostname
# Recipe:: default
#

#node.name = Chef::Config[:node_name]

# Update the server's repos apt package DB (sudo apt-get update)
execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
    File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

service "hostname" do
  supports :restart => true
end

service "networking" do
  supports :restart => true
end

template "/etc/hosts" do
  source "hosts.erb"
  owner 'root'
  group 'root'
  mode 00644
  #notifies :restart, "service[hostname]"
  #notifies :restart, "service[networking]"
end

file '/etc/hostname' do
  content "#{node.name}"
  owner 'root'
  group 'root'
  mode 00644
  #notifies :restart, "service[hostname]"
  #notifies :restart, "service[networking]"
end

execute "restart hostname service" do
  command "sudo service hostname restart"
end

#execute "restart networking service" do
#  command "sudo service networking restart"
#end

