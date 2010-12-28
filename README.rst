Mediawiki farm module
=======================================

Puppet Module to create many wikis (on the same machine) using only one mediawiki installation.

Usage
-----

Parameters available::

  mediawiki::new { "Name":
    ensure      => present, enabled, disabled, absent
    admin       => foo@bar.com
    servername  => foo.bar.com      #Default to $name
    serveralias => foo              #Default to $name
    ip          => 127.0.0.1        #IP for apache configuration. Default to *
    port        => 80               #Port for apache configuration. Default to 80
  }

Notes
-----

* Tested OS: Ubuntu 9.10, 10.04.1 LTS
* Tested Mediawiki versions: 1:1.15.0-1.1ubuntu0.4, 1:1.15.1-1ubuntu2.1
