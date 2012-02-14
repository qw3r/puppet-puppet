class puppet {
	define puppet::config ($config = false) {
		file { "$name":
			owner   => root,
			group   => root,
			mode    => 0644,
			alias   => "puppet.conf",
			source  => "puppet:///modules/puppet/etc/puppet/puppet-${config}.conf",
			notify  => Service["puppet"],
			require => Package["puppet"],			
		}
	}

	file { "/etc/default/puppet":
		owner   => root,
		group   => root,
		mode    => 0644,
		alias   => "puppet",
		source  => "puppet:///modules/puppet/etc/default/puppet",
		notify  => Service["puppet"],
		require => Package["puppet"],
	}

	file { "/etc/puppet/namespaceauth.conf":
		owner   => root,
		group   => root,
		mode    => 0644,
		alias   => "namespaceauth.conf",
		content => template("puppet/etc/puppet/namespaceauth.conf.erb"),
		notify  => Service["puppet"],
		require => Package["puppet"],
	}

	puppet::config { "/etc/puppet/puppet.conf":
		config => "agent",
	}

	package { "puppet":
		ensure => present,
	}

	service { "puppet":
		enable     => true,
		ensure     => running,
		hasrestart => true,
		hasstatus  => true,
		require    => [
			File["puppet"],
			File["namespaceauth.conf"],
			File["puppet.conf"],
			Package["puppet"]
		],
	}
}

# vim: tabstop=3