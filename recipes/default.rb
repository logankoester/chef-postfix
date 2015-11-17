package('postfix') { action :install }

credentials_path = '/etc/postfix/sasl_passwd'

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
  variables mynetworks_style: node[:postfix][:mynetworks_style]
end

file credentials_path do
  action :create
  mode '600'
end

bash 'Configure sasl_passwd for postfix' do
  credentials = "#{node[:postfix][:relayhost]} #{node[:postfix][:smtp][:login]}:#{node[:postfix][:smtp][:password]}"
  code <<-EOH
    echo '#{credentials}' > #{credentials_path}
    postmap #{credentials_path}
  EOH
  not_if { File.exists?(credentials_path) && File.read(credentials_path).strip == credentials }
  notifies :restart, resources(:service => 'postfix')
end
