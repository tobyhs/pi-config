remote_file '/etc/systemd/system/mnt-videoarchive.mount' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'mnt-videoarchive.mount' do
  action [:enable, :start]
  subscribes :restart, 'remote_file[/etc/systemd/system/mnt-videoarchive.mount]'
end
