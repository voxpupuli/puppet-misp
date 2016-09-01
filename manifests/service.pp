
class misp::service inherits misp {

  require '::misp::config'

  service { 'rh-php56-php-fpm':
    ensure    => 'running',
    enable    => true,
    subscribe => File['/etc/opt/rh/rh-php56/php.d/99-redis.ini'], #Needs the subscribe, cannot notify a service
  }

  service { 'haveged':
    ensure => 'running',
    enable => true,
  }

  service { 'redis':
    ensure => 'running',
    enable => true,
  }

  exec {'start bg workers':
    command => "/usr/bin/chmod +x /var/www/MISP/app/Console/worker/start.sh && /usr/bin/su -s /bin/bash apache -c '/usr/bin/scl enable rh-php56 ${install_dir}app/Console/worker/start.sh'",
    user    => 'root',
    group   => 'apache',
  }
}