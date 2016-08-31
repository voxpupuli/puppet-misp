
class misp::config inherits misp {

  require '::misp::install'

  # Apache permissions

  exec {'Directory permissions':
    command     => '/usr/bin/chown -R root:apache /var/www/MISP && /usr/bin/find /var/www/MISP -type d -exec /usr/bin/chmod g=rx {} \; && /usr/bin/chmod -R g+r,o= /var/www/MISP',
    refreshonly => true, #Might be a problem with updates. It will only be executed if the full installation goes through
    subscribe   => File['/var/www/MISP/app/Plugin/CakeResque/Config/config.php'],
  }

  file {'/var/www/MISP/app/files' :
    ensure    => directory,
    owner     => 'apache',
    group     => 'apache',
    seltype   => 'httpd_sys_content_rw_t',
    recurse   => false,
    subscribe => Exec['Directory permissions'],
    notify    => File['/var/www/MISP/app/files/terms','/var/www/MISP/app/files/scripts/tmp'],
  }

  file {'/var/www/MISP/app/files/terms' :
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    seltype => 'httpd_sys_content_rw_t',
    recurse => false,
  }

  file {'/var/www/MISP/app/files/scripts/tmp' :
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    seltype => 'httpd_sys_content_rw_t',
    recurse => false,
  }

  file {'/var/www/MISP/app/Plugin/CakeResque/tmp' :
    ensure    => directory,
    owner     => 'apache',
    group     => 'apache',
    seltype   => 'httpd_sys_content_rw_t',
    recurse   => false,
    subscribe => Exec['Directory permissions'],
  }

  file {'/var/www/MISP/app/tmp' :
    ensure    => directory,
    owner     => 'apache',
    group     => 'apache',
    recurse   => true,
    seltype   => 'httpd_sys_content_rw_t',
    subscribe => Exec['Directory permissions'],
  }

  file {'/var/www/MISP/app/webroot/img/orgs' :
    ensure    => directory,
    owner     => 'apache',
    group     => 'apache',
    recurse   => true,
    seltype   => 'httpd_sys_content_rw_t',
    subscribe => Exec['Directory permissions'],
  }

  file {'/var/www/MISP/app/webroot/img/custom' :
    ensure    => directory,
    owner     => 'apache',
    group     => 'apache',
    recurse   => true,
    seltype   => 'httpd_sys_content_rw_t',
    subscribe => Exec['Directory permissions'],
  }

  file { "${config_dir}bootstrap.php":
    ensure    => file,
    owner     => 'root',
    group     => 'apache',
    source    => 'file:///var/www/MISP/app/Config/bootstrap.default.php',
    subscribe => Exec['Directory permissions'],
  }

  file { "${config_dir}core.php":
    ensure    => file,
    owner     => 'root',
    group     => 'apache',
    source    => 'file:///var/www/MISP/app/Config/core.default.php',
    subscribe => Exec['Directory permissions'],
  }

  file{"${config_dir}database.php":
    ensure    => file,
    owner     => 'root',
    group     => 'apache',
    mode       => '640',
    content   => template('misp/database.php.erb'),
    subscribe => Exec['Directory permissions'],
  }

  file{"${config_dir}config.php":
    ensure    => file,
    owner     => 'apache',
    group     => 'apache',
    content   => template('misp/config.php.erb'),
    seltype   => 'httpd_sys_content_rw_t',
    subscribe => Exec['Directory permissions'],
  }

  exec{'setsebool redis':
    command   => '/usr/sbin/setsebool -P httpd_can_network_connect on',
    subscribe => File['/etc/opt/rh/rh-php56/php.d/99-redis.ini'],
    notify    => Service[$webservername],
  }
}