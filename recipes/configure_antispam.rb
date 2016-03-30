%w{
  postgrey 
  spamassassin 
  spamass-milter-postfix 
  spamass-milter 
  clamav-filesystem 
  clamav-server 
  clamav-update 
  clamav-milter-systemd 
  clamav-data 
  clamav-server-systemd 
  clamav-scanner-systemd 
  clamav 
  clamav-milter 
  clamav-lib 
  clamav-scanner
}.each do |pkg|
  yum_package pkg do
    action :install
  end
end

cookbook_file '/etc/clamd.d/scan.conf' do
  source 'scan.conf'
end

cookbook_file '/etc/mail/clamav-milter.conf' do
  source 'clamav-milter.conf'
end

%w(spamassassin.service 
   spamass-milter.service 
   spamass-milter-root.service
   clamd@scan.service
   clamav-milter.service
   postgrey.service
   postfix.service
).each do |svc|
  service svc do
  action [:enable, :start]
  end
end
