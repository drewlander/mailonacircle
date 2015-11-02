service 'dovecot' do
  action [:start, :enable]
end

template '/etc/dovecot/dovecot-sql.conf.ext' do
  source 'dovecot-sql.conf.ext.erb'
  notifies :restart, 'service[dovecot]'
end

cookbook_file '/etc/dovecot/conf.d/10-auth.conf' do
  source '10-auth.conf'
  notifies :restart, 'service[dovecot]'
end

cookbook_file '/etc/dovecot/conf.d/10-mail.conf' do
  source '10-mail.conf'
  notifies :restart, 'service[dovecot]'
end

cookbook_file '/etc/dovecot/conf.d/10-master.conf' do
  source '10-master.conf'
  notifies :restart, 'service[dovecot]'
end

template '/etc/dovecot/conf.d/10-ssl.conf' do
  source '10-ssl.conf.erb'
  notifies :restart, 'service[dovecot]'
end

cookbook_file '/etc/dovecot/conf.d/auth-sql.conf.ext' do
  source 'auth-sql.conf.ext'
  notifies :restart, 'service[dovecot]'
end

execute 'dovecot firewall commands' do
  command <<-EOF
  firewall-cmd --zone=public --add-service=smtp 
  firewall-cmd --zone=public --add-service=smtps
  firewall-cmd --zone=public --add-port=587/tcp
  firewall-cmd --zone=public --add-service=imaps
  firewall-cmd --zone=public --add-service=imap 
  firewall-cmd --zone=public --add-service=pop3s
  firewall-cmd --zone=public --add-service=smtp --permanent
  firewall-cmd --zone=public --add-service=smtps --permanent
  firewall-cmd --zone=public --add-port=587/tcp --permanent
  firewall-cmd --zone=public --add-service=imaps --permanent
  firewall-cmd --zone=public --add-service=imap --permanent
  firewall-cmd --zone=public --add-service=pop3s --permanent
  EOF
end
