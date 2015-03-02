node default {
  class { 'php': }
  class { 'apache':
    mpm_module => 'prefork',
    user => 'vagrant',
    group => 'vagrant',
  }
  include apache::mod::php
  include apache::mod::rewrite

  php::module { "mcrypt": }
  php::module { "curl": }
  php::module { "gd": }
  php::module { "mysql": }

  apache::vhost { 'meetmagento.lo':
    port    => '80',
    docroot => '/vagrant/magento',
  }

  class { '::mysql::server':
    root_password  => 'foobar',
  }

  mysql::db { 'magento':
    user     => 'meetmagento',
    password => 'm4g3nt0',
  }

  file { 'mcrypt':
      path    => '/etc/php5/apache2/conf.d/30-mcrypt.ini',
      ensure  => '/vagrant/puppet/resources/mcrypt.ini',
      require => Class['php'],
      notify => Service['apache2'],
  }
}
