service 'nginx' do
  action :nothing
end
directory '/var/www/html/postfixadmin' do
  action :create
end

remote_file '/tmp/postfixadmin.tar.gz' do
  source node['postfixadmin']['postfixadmin_download_url']
  user 'nginx'
  group 'nginx'
  not_if {File.exists? '/tmp/postfixadmin.tar.gz'}
end

execute 'untar postfixadmin source' do
  command 'tar -xzvf /tmp/postfixadmin.tar.gz -C /var/www/html/postfixadmin --strip-components=1'
  not_if {File.exists? '/var/www/html/postfixadmin/main.php'}
end

template '/var/www/html/postfixadmin/config.inc.php' do
  source 'config.inc.php.erb'
  notifies :restart, 'service[nginx]'
end

execute 'change www perms' do
  command 'chown -R nginx:nginx /var/www/html/postfixadmin'
end
#file '/tmp/postfixadmin.sql' do
#  content "INSERT INTO admin(username,password,superadmin,created,modified,active) VALUES('postfixadmin', '#{node['postfixadmin']['md5crypt_pw']}', 1, NOW(), NOW(), 1);"
#end
#
#execute 'run_sql_commands' do
#  command "mysql -u#{node['mysql']['mysql_username']} -p#{node['mysql']['mysql_password']} #{node['mysql']['mail_database_name']} < /tmp/postfixadmin.sql"
#  not_if {File.exists? '/tmp/postfixadmin_user_created'}
#end
#
#file '/tmp/postfixadmin_user_created' do
#  content 'created'
#end
#
execute 'fix_selinux_template_smarty' do
  command "semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/postfixadmin/templates_c'"
end

execute 'restorecon template'do
  command "restorecon -v '/var/www/html/postfixadmin/templates_c'"
end

