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

execute 'start all the things' do
  command <<-EOF
  systemctl enable spamassassin.service
  systemctl start spamassassin.service
  systemctl enable spamass-milter.service
  systemctl enable spamass-milter-root.service
  systemctl start spamass-milter.service
  #systemctl start spamass-milter-root.service
  systemctl enable clamd@scan.service
  systemctl start clamd@scan.service
  systemctl enable clamav-milter.service
  systemctl start clamav-milter.service
  systemctl enable postgrey.service
  systemctl start postgrey.service
  systemctl restart postfix.service
  EOF
end
