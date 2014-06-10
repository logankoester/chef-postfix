package('postfix') { action :install }

service 'postfix' do
  provider Chef::Provider::Service::Systemd if node['platform'] =~ /arch|manjaro/
  supports status: true, start: true, stop: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/postfix/main.cf' do
  mode '0644'
  source 'main.cf.erb'
  notifies :reload, resources(:service => 'postfix')
  variables relayhost: node[:postfix][:relayhost]
end

bash 'Configure sasl_passwd for postfix' do
  code "echo '#{node[:postfix][:relayhost]} #{node[:postfix][:smtp][:login]}:#{node[:postfix][:smtp][:password]}' > /etc/postfix/sasl_passwd"
end

bash 'Set permissions for the sasl_passwd' do
  code 'chmod 600 /etc/postfix/sasl_passwd'
end

bash 'Postmap the sasl_password' do
  code 'postmap /etc/postfix/sasl_passwd'
  notifies :restart, resources(:service => 'postfix')
end
