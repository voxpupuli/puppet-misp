
class misp::install inherits misp {

  require '::misp::dependencies'

  # MISP

  vcsrepo { $misp::install_dir:
    ensure     => present,
    provider   => git,
    submodules => true,
    force      => false,
    source     => 'https://github.com/MISP/MISP.git',
    revision   => $misp::misp_git_tag,
  }

  exec {'git ignore permissions':
    command     => '/usr/bin/git config core.filemode false',
    cwd         => $misp::install_dir,
    refreshonly => true,
    subscribe   => Vcsrepo[$misp::install_dir],
    notify      => Vcsrepo["${misp::install_dir}/app/files/scripts/python-cybox","${misp::install_dir}/app/files/scripts/python-stix"],
  }

  vcsrepo { "${misp::install_dir}/app/files/scripts/python-cybox":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::cybox_git_repo,
    revision => $misp::cybox_git_tag,
  }

  vcsrepo { "${misp::install_dir}/app/files/scripts/python-stix":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::stix_git_repo,
    revision => $misp::stix_git_tag,
  }

  exec {'python-cybox config':
    command     => '/usr/bin/git config core.filemode false && /usr/bin/python setup.py install',
    cwd         => "${misp::install_dir}/app/files/scripts/python-cybox/",
    unless      => '/usr/bin/pip list | grep cybox',
    umask       => '0022',
    refreshonly => true,
    subscribe   => Vcsrepo["${misp::install_dir}/app/files/scripts/python-cybox"],
  }

  exec {'python-stix config':
    command     => '/usr/bin/git config core.filemode false && /usr/bin/python setup.py install',
    cwd         => "${misp::install_dir}/app/files/scripts/python-stix/",
    unless      => '/usr/bin/pip list | grep stix',
    umask       => '0022',
    refreshonly => true,
    subscribe   => Vcsrepo["${misp::install_dir}/app/files/scripts/python-stix"],
  }

  # CakePHP

  exec {'CakeResque curl':
    command     => '/usr/bin/curl -s https://getcomposer.org/installer | php',
    cwd         => "${misp::install_dir}/app/",
    environment => ["COMPOSER_HOME=${misp::install_dir}/app/"],
    refreshonly => true,
    notify      => Exec['CakeResque kamisama'],
    subscribe   => Exec['git ignore permissions'],
  }

  exec {'CakeResque kamisama':
    command     => '/usr/bin/php composer.phar require kamisama/cake-resque:4.1.2',
    cwd         => "${misp::install_dir}/app/",
    environment => ["COMPOSER_HOME=${misp::install_dir}/app/"],
    refreshonly => true,
    notify      => Exec['CakeResque config'],
  }

  exec {'CakeResque config':
    command     => '/usr/bin/php composer.phar config vendor-dir Vendor',
    cwd         => "${misp::install_dir}/app/",
    environment => ["COMPOSER_HOME=${misp::install_dir}/app/"],
    refreshonly => true,
    notify      => Exec['CakeResque install'],
  }

  exec {'CakeResque install':
    command     => '/usr/bin/php composer.phar install',
    cwd         => "${misp::install_dir}/app/",
    environment => ["COMPOSER_HOME=${misp::install_dir}/app/"],
    refreshonly => true,
    notify      => File['/etc/opt/rh/rh-php56/php-fpm.d/redis.ini', '/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini'],
  }

  file {'/etc/opt/rh/rh-php56/php-fpm.d/redis.ini':
    ensure  => file,
    content => 'extension=redis.so',
  }

  file {'/etc/opt/rh/rh-php56/php.d/99-redis.ini':
    ensure    => link,
    target    => '/etc/opt/rh/rh-php56/php-fpm.d/redis.ini',
    subscribe => File['/etc/opt/rh/rh-php56/php-fpm.d/redis.ini'],
  }

  file {'/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini':
    ensure  => file,
    content => "date.timezone = '${misp::timezone}'",
  }

  file {'/etc/opt/rh/rh-php56/php.d/99-timezone.ini':
    ensure    => link,
    target    => '/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini',
    subscribe => File['/etc/opt/rh/rh-php56/php-fpm.d/timezone.ini'],
  }

  #File cration for managing workers

  file { "${misp::install_dir}/app/Console/worker/status.sh":
    ensure    => file,
    source    => "puppet:///modules/${module_name}/status.sh",
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    mode      => '0755',
    subscribe => Vcsrepo[$misp::install_dir],
  }

  # Logrotate

  #file {'/etc/logrotate.d/misp':
  #  ensure => file,
  #  source => "puppet:///modules/${module_name}/misp.logrotate",
  #  owner  => $misp::default_high_user,
  #  group  => $misp::default_high_group,
  #  mode   => '0755',
  #}

  #selinux::module{ 'misplogrotate':
  #  source    => "puppet:///modules/${module_name}/misplogrotate.te",
  #  subscribe => File['/etc/logrotate.d/misp'],
  #}
}
