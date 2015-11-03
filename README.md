mailonacircle Cookbook
======================
There is a LOT TO DO, but it works for me so far.
This was created because there is mailinabox for ubuntu, but nothing for centos

This cookbook is a side project that does the following:
* Installs and configures:
  * postfix
  * dovecot
  * mariadb
  * spamassassin
  * postgrey-milter
  * clamav-milter
  * opendkim
  * postscreen

Manual Steps:
* After installing postfixadmin, you have to go to:
  * https://yoursite.com/setup.php and let it set things up, and copy the hash to
    * /var/www/html/postfixadmin/config.inc.php 
  * Setup your domains/mailboxes in postfixadmin (or direct sql)
  * Copy opendkim keys to your DNS TXT records

Requirements
------------
  * Centos 7
  * desginged to be run by chef-solo (currently)
  * assumues selinux is at least in permissive (enforcing recommended)

#### packages
- `toaster` - mailonacircle needs toaster to brown your bagel.

Attributes
----------
TODO: List your cookbook attributes here.

#### mailonacircle::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mailonacircle']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### mailonacircle::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `mailonacircle` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mailonacircle]"
  ]
}
```

Contributing
------------
Contributions are welcome! This is a side project. 
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: drewlander <drewski@drewstud.com>
