node default {
	file {
		"/root/init_scripts/":
			ensure => directory;

		"/root/init_scripts/conf.ini":
			require => File["/root/init_scripts/"];
		
		"/root/init_scripts/init.sh":
			source => "puppet:///files/node/default/init.sh";
	}

	augeas {
		"init_vm_config_ini":
			lens => "Shellvars.lns",
			incl => "/root/init_scripts/conf.ini",
			changes => [
				"set puppet_server $config::global::host_puppet_server",
				"set root_domain $config::global::root_domain_name"
			],
			require => File["/root/init_scripts/conf.ini"],
	}

	yum::repo::conf {
		["centos_base", "centos_updates", "centos_extras", "epel"]:
	}

	hosts::conf {
		$config::hosts::ip_keys:
	}

	puppet::client::conf {
		"main/server":
			ensure => "puppet-server.vip.$config::global::root_domain_name",
	}

	include role_puppet_client, role_ssh_server
}
