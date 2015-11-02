cookbook_file '/etc/yum.repos.d/nginx.repo' do
  source 'nginx.repo'
end

yum_package 'nginx' do
  flush_cache [ :before ]
  action :install
end

%w{php 
  php-fpm 
  php-common 
  php-pdo 
  php-mbstring 
  php-imap 
  php-cli 
  php-mysql 
  nginx}.each do |pkg|
    package pkg do
      action :install
  end  
end

cookbook_file '/etc/php-fpm.d/www.conf' do
  source 'www.conf'
  notifies :restart, 'service[php-fpm]'
end

template '/etc/nginx/conf.d/postfixadmin.conf' do
  source 'postfixadmin_nginx.conf.erb'
  notifies :restart, 'service[nginx]'
end

execute 'open nginx ports' do
  command 'firewall-cmd --zone=public --add-service=http --permanent; firewall-cmd --zone=public --add-service=http'
end

execute 'selinux yay' do
  command 'setsebool -P httpd_can_sendmail 1'
  not_if {`getsebool httpd_unified | grep 1`}
end

execute 'selinux nginx' do
  command 'setsebool -P httpd_unified on'
  not_if {`getsebool httpd_unified | grep on`}
end

execute 'generate ssl key' do
  command "openssl req -subj '/CN=#{node['nginx']['postfixadmin_servername']}/O=My Company Name LTD./C=US' -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/pki/tls/private/#{node['nginx']['postfixadmin_servername']}.key -out /etc/pki/tls/certs/#{node['nginx']['postfixadmin_servername']}.crt"
end

execute 'fix_session_perms' do
  command 'chown nginx:nginx /var/lib/php/session'
end

service 'nginx' do
  action [:start, :enable]
end

service 'php-fpm' do
  action [:start, :enable]
end

 execute 'fix_selinux_template_smarty' do
  command "semanage fcontext -a -t httpd_sys_rw_content_t '/var/www/html/postfixadmin/templates_c'" 
end

execute 'restorecon template'do
  command "restorecon -v '/var/www/html/postfixadmin/templates_c'"
end
