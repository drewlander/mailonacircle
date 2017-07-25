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

package 'epel-release' do
  action :install
end


%w{mod_ssl crypto-utils mariadb-server dovecot dovecot-mysql checkpolicy}.each do |pkg| 
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

cookbook_file '/tmp/my-spamassmilter.te' do
  source 'my-spamassmilter.te'
end
execute 'create_clamav_milter_selinux_policy' do
  command <<-EOF
    checkmodule -M -m -o /tmp/my-spamassmilter.mod /tmp/my-spamassmilter.te
    semodule_package -o /tmp/my-spamassmilter.pp -m /tmp/my-spamassmilter.mod
    semodule -i /tmp/my-spamassmilter.pp   
  EOF
  not_if {File.exists? '/tmp/my-spamassmilter.pp'}
end

cookbook_file '/tmp/my-smtpd.te' do
  source 'my-smtpd.te'
end

execute 'create_clamav_milter_socket_selinux_policy' do
  command <<-EOF
    checkmodule -M -m -o /tmp/my-smtpd.mod /tmp/my-smtpd.te
    semodule_package -o /tmp/my-smtpd.pp -m /tmp/my-smtpd.mod
    semodule -i /tmp/my-smtpd.pp   
  EOF
  not_if {File.exists? '/tmp/my-smtpd.pp'}
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

execute 'allow clamav-milter port' do
  command 'semanage port -a -t milter_port_t -p tcp 7357 || echo "already defined"'
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
