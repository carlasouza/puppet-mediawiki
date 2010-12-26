define mediawiki::new(
	$ensure=present,
	$admin,
	$servername=$name,
	$serveralias=$name,
	$ip='*',
	$port=80) {

	case $ensure {
		present:  {
			package { "mediawiki":
				ensure	=> latest,
			}
		
			file { "wikis":
				path		=> "/var/lib/mediawiki/wikis",
				owner    => "root",
				group    => "root",
				ensure   => directory,
				mode     => 755,
				require	=> Package["mediawiki"];
			}
		
			file { "mywiki":
				path		=> "/var/lib/mediawiki/wikis/${name}",
		      owner    => "root",
		      group    => "root",
		      ensure   => directory,
		      mode     => 755,
		      require  => File["wikis"];
			}
		
			file {
				["/var/lib/mediawiki/wikis/${name}/upload",
				"/var/lib/mediawiki/wikis/${name}/images",
				"/var/lib/mediawiki/wikis/${name}/config"]:
					owner		=> "www-data",
					group		=> "www-data",
					ensure	=> directory,
					require  => File["mywiki"],
					notify   => File["/var/lib/mediawiki/wikis/${name}/config/index.php"],
					mode		=>	700;
				"/var/lib/mediawiki/wikis/${name}/extensions":
					owner		=> "root",
					group		=> "root",
					ensure	=> directory,
					require  => File["mywiki"],
					mode		=> 755;
				"/var/lib/mediawiki/wikis/${name}/config/index.php":
#					source => "puppet:///modules/mediawiki/index.php",
					content => template("mediawiki/index.php.erb"),
					owner  => "www-data",
               group  => "www-data",
					mode   => 700;
			}
			
		#	file {"/var/lib/mediawiki/wikis/${name}/LocalSettings.php":
		#		content => template();
		#	}
		
		#     if ( file_exists( "config/LocalSettings.php" ) ) {
		#         echo( "To complete the installation, move <tt>config/LocalSettings.php</tt> to the parent directory." );
		#		defaultsettings.php
		#		$wgUploadPath       = "{$wgScriptPath}/upload";
		#		$wgUploadDirectory      = "{$IP}/upload";
		
			file {
				"/var/lib/mediawiki/wikis/${name}/api.php":
					ensure  => "/usr/share/mediawiki/api.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/img_auth.php":
					ensure  => "/usr/share/mediawiki/img_auth.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/includes":
					ensure  => "/usr/share/mediawiki/includes",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/index.php":
					ensure  => "/usr/share/mediawiki/index.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/install-utils.inc":
					ensure  => "/usr/share/mediawiki/install-utils.inc",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/languages":
					ensure  => "/usr/share/mediawiki/languages",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/maintenance":
					ensure  => "/usr/share/mediawiki/maintenance",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/opensearch_desc.php":
					ensure  => "/usr/share/mediawiki/opensearch_desc.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/profileinfo.php":
					ensure  => "/usr/share/mediawiki/profileinfo.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/redirect.php":
					ensure  => "/usr/share/mediawiki/redirect.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/redirect.phtml":
					ensure  => "/usr/share/mediawiki/redirect.phtml",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/skins":
					ensure  => "/usr/share/mediawiki/skins",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/StartProfiler.php":
					ensure  => "/usr/share/mediawiki/StartProfiler.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/Test.php":
					ensure  => "/usr/share/mediawiki/Test.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/thumb.php":
					ensure  => "/usr/share/mediawiki/thumb.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/trackback.php":
					ensure  => "/usr/share/mediawiki/trackback.php",
					require => File["mywiki"];
				"/var/lib/mediawiki/wikis/${name}/wiki.phtml":
					ensure  => "/usr/share/mediawiki/wiki.phtml",
					require => File["mywiki"];
			}


		file {"apache-file":
			path		=> "/etc/apache2/sites-available/${name}",
			content	=> template("mediawiki/wiki.erb");
#			notify a2ensite and apache reload
		}


		}
#		disable: {
#		}
#		absent:{
#		}
	}
}

#class apache {
#	
#	package { "apache2":
#		ensure => latest;
#	}
#
#	service { "apache2":
#		require		=> Package["httpd"],
#		subscribe	=> File["apache-file"];
#	}
#
#	file {"apache-file":
#		path		=> "/etc/apache2/sites-enable/${name}",
#		content	=> template("wiki.erb");
#	}
#
#}
