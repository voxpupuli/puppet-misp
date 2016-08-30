
class misp::config ($db_name = 'misp', $db_user = 'misp', $db_host = 'misp.com', $db_port = '5505', $git_tag='v2.4.51',
  $salt='Rooraenietu8Eeyo<Qu2eeNfterd-dd+', $cipherseed='',
  $orgname = 'ORGNAME', $webservername = 'httpd', $email = 'root@localhost', $contact = 'root@localhost',
  $live = 'true', $site_admin_debug = 'false',
  $gnu_email = 'no-reply@localhost', $gnu_homdir = '/var/www/html') inherits misp {

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

  file { '/var/www/MISP/app/Config/bootstrap.php':
    ensure    => file,
    owner     => 'root',
    group     => 'apache',
    source    => 'file:///var/www/MISP/app/Config/bootstrap.default.php',
    subscribe => Exec['Directory permissions'],
  }

  file { '/var/www/MISP/app/Config/core.php':
    ensure    => file,
    owner     => 'root',
    group     => 'apache',
    source    => 'file:///var/www/MISP/app/Config/core.default.php',
    subscribe => Exec['Directory permissions'],
  }

  teigi::secret::sub_file{'/var/www/MISP/app/Config/database.php':
    teigi_keys => ['misp_db_password'],
    template   => 'misp/database.php.erb',
    subscribe  => Exec['Directory permissions'],
    owner      => 'root',
    group      => 'apache',
    mode       => '640',
  }

  file{'/var/www/MISP/app/Config/config.php':
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