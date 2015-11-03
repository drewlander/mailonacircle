default['mysql']['mysql_username'] = 'root'
default['postfix']['mysql_postfix_username'] = 'postfix'
default['mysql']['mysql_password'] = '123456'
default['postfix']['mysql_postfix_password'] = '1234567'
default['mysql']['mail_database_name'] = 'mail'

default['postfix']['inet_interfaces'] = 'all'
default['postfix']['my_domain'] = 'test.com'
default['postfix']['my_hostname'] = 'testhost'

default['postfixadmin']['postfixadmin_username'] = 'postfixadmin'
default['postfixadmin']['postfixadmin_password'] = 'abc123'
default['postfixadmin']['md5crypt_pw'] = '$1$y17yIJD1$DgFXoo1LGKWr8446FIe4q0'
default['postfixadmin']['postfixadmin_download_url'] = 'http://downloads.sourceforge.net/project/postfixadmin/postfixadmin/postfixadmin-2.93/postfixadmin-2.93.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpostfixadmin%2Ffiles%2F&ts=1446337172&use_mirror=iweb'

default['nginx']['postfixadmin_port'] = '443'
default['nginx']['postfixadmin_servername'] = 'mail.test.com'
