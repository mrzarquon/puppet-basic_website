class basic_website::with_sysctl {
  include apache  
  
  $ipv4_tcp_keepalive_time = pick($::sysctl_ipv4_tcp_keepalive_time, hiera('sysctl_ipv4_tcp_keepalive_time','7200'))

  package{'git':
    name       => $osfamily ? {
      "Redhat" => "git",
      "Debian" => "git-core",
    },
    ensure     => present
  }

  firewall{'1120 basic web service':
    action => 'accept',
    dport  => '80',
    proto  => 'tcp',
  }
  
  apache::vhost {"${::hostname}":
    priority   => '10',
    vhost_name => "${::hostname}",
    port       => '80',
    docroot    => "/var/${::hostname}",
  }

  sysctl { 'net.ipv4.tcp_keepalive_time':
    ensure    => present,
    permanent => 'yes',
    value     => $ipv4_tcp_keepalive_time,
  }

  vcsrepo{"/var/${::hostname}":
    ensure   => present,
    provider => 'git',
    source   => "git://github.com/mrzarquon/genericwebsite.git",
    require  => Package['git'],
    before   => Apache::Vhost["${::hostname}"],
  }
}
