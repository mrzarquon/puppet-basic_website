class basic_website {
  include apache  

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

  vcsrepo{"/var/www/${::hostname}":
    ensure   => latest,
    provider => 'git',
    source   => "git://github.com/mrzarquon/genericwebsite.git",
    require  => Package['git'],
  }


}
