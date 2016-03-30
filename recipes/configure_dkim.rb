%w{libopendkim opendkim}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

cookbook_file '/etc/opendkim.conf' do
  source 'opendkim.conf'
end

template '/etc/opendkim/TrustedHosts' do
  source 'TrustedHosts.erb'
end

template '/etc/opendkim/KeyTable' do
  source 'KeyTable.erb'
end

template '/etc/opendkim/SigningTable' do
  source 'SigningTable.erb'
end


directory "/etc/opendkim/keys/#{node['postfix']['my_domain']}" do
  action :create
  recursive true
end

execute 'generate_keys' do
  command <<-EOF
    chown -R opendkim.opendkim /etc/opendkim/keys/#{node['postfix']['my_domain']}
    opendkim-genkey -s default -d #{node['postfix']['my_domain']}
    chown -R opendkim. /etc/opendkim/keys/
    chown -R opendkim.opendkim /etc/opendkim/keys/
  EOF
  cwd "/etc/opendkim/keys/#{node['postfix']['my_domain']}"
  not_if {File.exists? "/etc/opendkim/keys/#{node['postfix']['my_domain']}/default.private"}
  notifies :restart, 'service[opendkim]'
end

service 'opendkim' do
action [:enable,:start]
end
