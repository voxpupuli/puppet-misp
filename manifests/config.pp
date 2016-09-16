
class misp::config inherits misp {

  require '::misp::install'

  # Apache permissions

  file { "${misp::install_dir}/app/Plugin/CakeResque/Config/config.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    source    => "file://${misp::install_dir}/INSTALL/setup/config.php",
    subscribe => Exec['CakeResque install'],
  }

  exec {'Directory permissions':
    command     => '/usr/bin/chown -R root:apache /var/www/MISP && /usr/bin/find /var/www/MISP -type d -exec /usr/bin/chmod g=rx {} \; && /usr/bin/chmod -R g+r,o= /var/www/MISP',
    refreshonly => true,
    require     => File["${misp::install_dir}/app/Plugin/CakeResque/Config/config.php"],
    subscribe   => Exec['CakeResque install'],
  }

  file {"${misp::install_dir}/app/files" :
    ensure    => directory,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    seltype   => 'httpd_sys_rw_content_t',
    recurse   => false,
    subscribe => Exec['Directory permissions'],
    notify    => File["${misp::install_dir}/app/files/terms","${misp::install_dir}/app/files/scripts/tmp"],
  }

  file {["${misp::install_dir}/app/files/terms","${misp::install_dir}/app/files/scripts/tmp"] :
    ensure  => directory,
    owner   => $misp::default_user,
    group   => $misp::default_group,
    seltype => 'httpd_sys_rw_content_t',
    recurse => false,
  }

  file {"${misp::install_dir}/app/Plugin/CakeResque/tmp" :
    ensure    => directory,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    seltype   => 'httpd_sys_rw_content_t',
    recurse   => false,
    subscribe => Exec['Directory permissions'],
  }

  file {["${misp::install_dir}/app/tmp","${misp::install_dir}/app/webroot/img/orgs", "${misp::install_dir}/app/webroot/img/custom"] :
    ensure    => directory,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    recurse   => true,
    seltype   => 'httpd_sys_rw_content_t',
    subscribe => Exec['Directory permissions'],
  }

  file { "${misp::config_dir}/bootstrap.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    source    => "file://${misp::install_dir}/app/Config/bootstrap.default.php",
    subscribe => Exec['Directory permissions'],
  }

  file { "${misp::config_dir}/core.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    source    => "file://${misp::install_dir}/app/Config/core.default.php",
    subscribe => Exec['Directory permissions'],
  }

  file{"${misp::config_dir}/database.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    mode      => '0640',
    content   => template('misp/database.php.erb'),
    subscribe => Exec['Directory permissions'],
  }

  file{"${misp::config_dir}/config.php":
    ensure    => file,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    content   => template('misp/config.php.erb'),
    seltype   => 'httpd_sys_rw_content_t',
    subscribe => Exec['Directory permissions'],
  }

  exec{'setsebool redis':
    command   => '/usr/sbin/setsebool -P httpd_can_network_connect on',
    unless    => '/usr/sbin/getsebool httpd_can_network_connect | grep -e  "--> on"',
    notify    => Service[$misp::webservername],
    subscribe => File['/etc/opt/rh/rh-php56/php.d/99-redis.ini'],
  }
}