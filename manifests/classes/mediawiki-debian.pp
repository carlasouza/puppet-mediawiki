class mediawiki::debian inherits mediawiki::base {

	package { 'mediawiki':
		ensure	=> latest,
	}

	file { 'wikis':
		path		=> '/var/lib/mediawiki/wikis',
		owner    => 'root',
		group    => 'root',
		ensure   => directory,
		mode     => 755;
		require	=> Package['mediawiki'] 
	}

	file {
		['/var/lib/mediawiki/wikis/resource[:name]/upload',
		'/var/lib/mediawiki/wikis/resource[:name]/images',
		'/var/lib/mediawiki/wikis/resource[:name]/config']:
			owner		=> 'www-data',
			group		=> 'www-data',
			ensure	=> directory,
			require => File['wikis'],
			mode		=>	700;
		'/var/lib/mediawiki/wikis/resource[:name]/extensions':
			owner		=> 'root',
			group		=> 'root',
			ensure	=> directory,
			require => File['wikis'],
			mode		=> 755;
	}
	
	file {'/var/lib/mediawiki/wikis/resource[:name]/LocalSettings.php':
		content => template();
	}

#		defaultsettings.php
#		$wgUploadPath       = '{$wgScriptPath}/upload';
#		$wgUploadDirectory      = '{$IP}/upload';

	file {
		'/var/lib/mediawiki/wikis/resource[:name]/api.php':
			ensure => '/usr/share/mediawiki/api.php';
		'/var/lib/mediawiki/wikis/resource[:name]/img_auth.php':
			ensure => '/usr/share/mediawiki/img_auth.php';
		'/var/lib/mediawiki/wikis/resource[:name]/includes':
			ensure => '/usr/share/mediawiki/includes';
		'/var/lib/mediawiki/wikis/resource[:name]/index.php':
			ensure => '/usr/share/mediawiki/index.php';
		'/var/lib/mediawiki/wikis/resource[:name]/install-utils.inc':
			ensure => '/usr/share/mediawiki/install-utils.inc';
		'/var/lib/mediawiki/wikis/resource[:name]/languages':
			ensure => '/usr/share/mediawiki/languages';
		'/var/lib/mediawiki/wikis/resource[:name]/maintenance':
			ensure => '/usr/share/mediawiki/maintenance';
		'/var/lib/mediawiki/wikis/resource[:name]/opensearch_desc.php':
			ensure => '/usr/share/mediawiki/opensearch_desc.php';
		'/var/lib/mediawiki/wikis/resource[:name]/profileinfo.php':
			ensure => '/usr/share/mediawiki/profileinfo.php';
		'/var/lib/mediawiki/wikis/resource[:name]/redirect.php':
			ensure => '/usr/share/mediawiki/redirect.php';
		'/var/lib/mediawiki/wikis/resource[:name]/redirect.phtml':
			ensure => '/usr/share/mediawiki/redirect.phtml';
		'/var/lib/mediawiki/wikis/resource[:name]/skins':
			ensure => '/usr/share/mediawiki/skins';
		'/var/lib/mediawiki/wikis/resource[:name]/StartProfiler.php':
			ensure => '/usr/share/mediawiki/StartProfiler.php';
		'/var/lib/mediawiki/wikis/resource[:name]/Test.php':
			ensure => '/usr/share/mediawiki/Test.php';
		'/var/lib/mediawiki/wikis/resource[:name]/thumb.php':
			ensure => '/usr/share/mediawiki/thumb.php';
		'/var/lib/mediawiki/wikis/resource[:name]/trackback.php':
			ensure => '/usr/share/mediawiki/trackback.php';
		'/var/lib/mediawiki/wikis/resource[:name]/wiki.phtml':
			ensure => '/usr/share/mediawiki/wiki.phtml';
	}
	
}

class apache {
	
	package { 'httpd':
		ensure => latest;
	}

	service { 'apache': require => Package['httpd'] }

	file {'apache-file'
		name		=> '/etc/apache2/sites-enable/resource[:name]',
		content	=> template('wiki.erb'),
		notify	=> service['apache'];
	}

}
