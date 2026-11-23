execute 'systemctl daemon-reload' do
  action :nothing
end

service 'systemd-journald' do
  action :start
end

remote_file '/etc/systemd/journald.conf.d/local.conf' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :reload, 'service[systemd-journald]'
end
