#
# Cookbook Name:: mailonacircle
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
service 'postfix' do
  action :nothing
end

%w{mod_ssl crypto-utils mariadb-server dovecot dovecot-mysql}.each do |pkg| 
   package pkg do
     action :install
   end
end

package 'postfix' do
  action :install
  notifies :restart, 'service[postfix]'
end

directory '/home/vmail' do
  action :create
  owner 'mail'
  group 'mail'
end

cookbook_file '/tmp/dovecotpol.te' do
  source 'dovecotpol.te'
end

execute 'create_dovecot_selinux_policy' do
  command <<-EOF
    checkmodule -M -m -o /tmp/dovecotpol.mod /tmp/dovecotpol.te
    semodule_package -o /tmp/dovecotpol.pp -m /tmp/dovecotpol.mod
    semodule -i /tmp/dovecotpol.pp   
    semanage fcontext -a -t mail_spool_t "/home/vmail(/.*)?"
    restorecon -R /home/vmail/
  EOF
  action :nothing
  not_if {File.exists? '/tmp/dovecotpol/pp'}
end

file '/tmp/dovecotpol' do
  content 'created'
  notifies :run, 'execute[create_dovecot_selinux_policy]', :immediately
end

include_recipe "mailonacircle::configure_mariadb"
include_recipe "mailonacircle::configure_postfix"
include_recipe "mailonacircle::configure_nginx"
include_recipe "mailonacircle::configure_postfixadmin"
include_recipe "mailonacircle::configure_dovecot"
include_recipe "mailonacircle::configure_antispam"
include_recipe "mailonacircle::configure_dkim"

execute 'allow postfix to talk to clamav' do
  command 'setfacl -m u:postfix:rx /var/run/clamav-milter'
end
