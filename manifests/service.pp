
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
  
}