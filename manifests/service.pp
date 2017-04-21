
class misp::service inherits misp {

  require '::misp::config'

  service { 'rh-php56-php-fpm':
    ensure    => 'running',
    enable    => true,
    subscribe => File['/etc/opt/rh/rh-php56/php.d/99-redis.ini']#], #Needs the subscribe, cannot notify a service
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
    command => "/usr/bin/su -s /bin/bash ${misp::default_user} -c '/usr/bin/scl enable rh-php56 ${misp::install_dir}/app/Console/worker/start.sh'",
    unless  => "/usr/bin/su -s /bin/bash ${misp::default_user} -c '/usr/bin/scl enable rh-php56 ${misp::install_dir}/app/Console/worker/status.sh'",
    user    => $misp::default_high_user,
    group   => $misp::default_high_group,
    require => Service[redis],
  }

  exec {'restart bg workers':
    command     => "/usr/bin/su -s /bin/bash ${misp::default_user} -c '/usr/bin/scl enable rh-php56 ${misp::install_dir}/app/Console/worker/start.sh'",
    user        => $misp::default_high_user,
    group       => $misp::default_high_group,
    refreshonly => true,
    subscribe   => Exec['CakeResque install'],
    require     => Service[redis],
  }
}