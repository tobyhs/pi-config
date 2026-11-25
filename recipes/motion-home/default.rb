package 'motion'

remote_file '/etc/motion/home.conf' do
  owner 'root'
  group 'root'
  mode '644'
end

remote_file '/etc/systemd/system/motion-home.service' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

start_hour = 7
start_minute = 10
end_hour = 22
end_minute = 0
now_tuple = Time.now.then { |now| [now.hour, now.min] }
service_active =
  ([start_hour, start_minute] <=> now_tuple) <= 0 &&
  (now_tuple <=> [end_hour, end_minute]) < 0

service 'motion-home' do
  action [:enable, service_active ? :start : :stop]
  if service_active
    subscribes :restart, 'remote_file[/etc/motion/home.conf]'
    subscribes :restart, 'remote_file[/etc/systemd/system/motion-home.service]'
  end
end

remote_file '/usr/local/bin/rm-old-motion-videos' do
  owner 'root'
  group 'root'
  mode '755'
end

template '/etc/cron.d/motion-home' do
  owner 'root'
  group 'root'
  mode '644'
  variables({ start_hour:, start_minute:, end_hour:, end_minute: })
end
