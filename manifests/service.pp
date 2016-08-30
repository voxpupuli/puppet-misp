
class misp::service inherits misp {

  require 'misp::install'

  service { 'rh-php56-php-fpm':
    enable => true,
    ensure => 'running',
    subscribe => File['/etc/opt/rh/rh-php56/php.d/99-redis.ini'], #Needs the subscribe, cannot notify a service
  }

  service { 'haveged':
    enable => true,
    ensure => 'running',
  }

  service { 'redis':
    enable => true,
    ensure => 'running',
  }

  exec {'start bg workers':
    command => '/usr/bin/chmod +x /var/www/MISP/app/Console/worker/start.sh && /usr/bin/su -s /bin/bash apache -c \'/usr/bin/scl enable rh-php56 /var/www/MISP/app/Console/worker/start.sh\'',
    user => 'apache',
    group => 'apache',
    subscribe => Exec['chcon config.php'],
  }
}