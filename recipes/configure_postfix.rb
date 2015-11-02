directory '/etc/postfix/sql' do
  action :create
end

file '/etc/postfix/postscreen_access.cidr' do
  content '127.0.0.0/8 permit'
end

directory '/home/vmail' do
  action :create
  owner 'mail'
  group 'mail'
end

service 'postfix' do
  action :nothing
end

template '/etc/postfix/main.cf' do
  source 'main.cf.erb'
  mode 0644
  notifies :restart, 'service[postfix]'
end

template '/etc/postfix/sql/mysql_relay_domains_maps.cf' do
  source 'mysql_relay_domains_maps.cf.erb' 
  notifies :restart, 'service[postfix]'
end

template '/etc/postfix/sql/mysql_virtual_alias_maps.cf' do
  source 'mysql_virtual_alias_maps.cf.erb'
  notifies :restart, 'service[postfix]'
end

template '/etc/postfix/sql/mysql_virtual_mailbox_limit_maps.cf' do
  source 'mysql_virtual_mailbox_limit_maps.cf.erb'
  notifies :restart, 'service[postfix]'
end

template '/etc/postfix/sql/mysql_virtual_mailbox_maps.cf' do
  source 'mysql_virtual_mailbox_maps.cf.erb'
  notifies :restart, 'service[postfix]'
end

template '/etc/postfix/sql/mysql_virtual_domains_maps.cf' do
  source 'mysql_virtual_domains_maps.cf.erb'
  notifies :restart, 'service[postfix]'
end

template '/etc/postfix/master.cf' do
  source 'master.cf.erb'
  notifies :restart, 'service[postfix]'
end
