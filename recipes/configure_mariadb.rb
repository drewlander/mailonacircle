service 'mariadb' do
  supports :status => true, :restart => true, :start => true
  action [:start, :enable]
end

execute 'set_mysql_password' do
  command "mysqladmin password #{node['mysql']['mysql_password']}"
  not_if {File.exists? '/tmp/mariadb_root_password_set'}
end

file '/tmp/mariadb_root_password_set' do
  content 'created'
end

execute 'create_mail_database' do
  command "mysqladmin create #{node['mysql']['mail_database_name']} -p#{node['mysql']['mysql_password']}"
  not_if {File.exists? '/tmp/mariadb_mail_db_created'}
end

file '/tmp/mariadb_mail_db_created' do
  content 'created'
end

execute 'create_postfixadmin_privileges' do
  command "mysql -u#{node['mysql']['mysql_username']} -p#{node['mysql']['mysql_password']} -e \"grant all privileges on #{node['mysql']['mail_database_name']} .* to '#{node['postfixadmin']['postfixadmin_username']}'@'localhost' identified by '#{node['postfixadmin']['postfixadmin_password']}';\""
  not_if {File.exists? '/tmp/mariadb_privs1_granted'}

end

file '/tmp/mariadb_privs1_granted' do
  content 'created'
end

execute 'create_postfixadmin_privileges' do
  command "mysql -u#{node['mysql']['mysql_username']} -p#{node['mysql']['mysql_password']} -e \"grant select on #{node['mysql']['mail_database_name']} .* to '#{node['postfix']['mysql_postfix_username']}'@'localhost' identified by '#{node['postfix']['mysql_postfix_password']}';\""
  not_if {File.exists? '/tmp/mariadb_privs2_granted'}

end

file '/tmp/mariadb_privs2_granted' do
  content 'created'
end

execute 'flush_privs' do
  command "mysql -u#{node['mysql']['mysql_username']} -p#{node['mysql']['mysql_password']} -e \"flush privileges;\""
end
