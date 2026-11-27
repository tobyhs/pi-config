package 'nebula'

group 'nebula'

user 'nebula' do
  gid 'nebula'
  home '/'
  system_user true
  shell '/usr/sbin/nologin'
end

directory '/etc/nebula' do
  owner 'nebula'
  group 'nebula'
  mode '750'
end

remote_file '/etc/nebula/ca.crt' do
  owner 'nebula'
  group 'nebula'
  mode '640'
  source '../../secrets/common/nebula/ca.crt'
  notifies :reload, 'service[nebula@home]'
end

remote_file '/etc/nebula/host.crt' do
  owner 'nebula'
  group 'nebula'
  mode '640'
  source "../../secrets/nodes/#{node['hostname']}/nebula/host.crt"
  notifies :reload, 'service[nebula@home]'
end

remote_file '/etc/nebula/host.key' do
  owner 'nebula'
  group 'nebula'
  mode '640'
  sensitive true
  source "../../secrets/nodes/#{node['hostname']}/nebula/host.key"
  notifies :reload, 'service[nebula@home]'
end

remote_file '/etc/nebula/home.yaml' do
  owner 'nebula'
  group 'nebula'
  mode '640'
  notifies :reload, 'service[nebula@home]'
end

remote_file '/etc/systemd/system/nebula@.service.d/non-root.conf' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
  notifies :reload, 'service[nebula@home]'
end

service 'nebula@home' do
  action [:enable, :start]
end
