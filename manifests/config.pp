
class misp::config inherits misp {

  require '::misp::install'
  include selinux
  
  # PHP ini memory configuration

  #php::fpm::config { 'php-ini':
  #  require => Package[rh-php56],
  #  file    => '/etc/opt/rh/rh-php56/php.ini',
  #  config  => [
  #    "set max_execution_time ${misp::php_max_execution_time}",
  #    "set memory_limit ${misp::php_memory_limit}M",
  #    "set upload_max_filesize ${misp::php_upload_max_filesize}M",
  #    "set post_max_size ${misp::php_post_max_size}M",
  #  ];
  #}

  # Apache permissions

  file { "${misp::install_dir}/app/Plugin/CakeResque/Config/config.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    source    => "file://${misp::install_dir}/INSTALL/setup/config.php",
    subscribe => Exec['CakeResque install'],
  }

  exec {'Directory permissions':
    command     => "/usr/bin/chown -R ${misp::default_high_user}:${misp::default_high_group} /var/www/MISP && /usr/bin/find ${misp::install_dir} -type d -exec /usr/bin/chmod g=rx {} \\; && /usr/bin/chmod -R g+r,o= ${misp::install_dir}",
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
    mode      => '0666',
    recurse   => true,
    seltype   => 'httpd_sys_rw_content_t',
    subscribe => Exec['Directory permissions'],
  }

  selinux::fcontext{'/var/www/MISP/app/tmp/logs(/.*)?' :
    filetype  => 'a',
    seltype   => 'httpd_log_t' ,
    subscribe => File["${misp::install_dir}/app/tmp","${misp::install_dir}/app/webroot/img/orgs", "${misp::install_dir}/app/webroot/img/custom"] ,
  }

  file {"${misp::install_dir}/app/tmp/logs/" :
    ensure    => directory,
    mode      => '0666',
    owner     => $misp::default_user,
    group     => $misp::default_group,
    recurse   => true,
    seltype   => 'httpd_log_t',
    subscribe => Selinux::fcontext['/var/www/MISP/app/tmp/logs(/.*)?'],
  }

  file { "${misp::config_dir}/bootstrap.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    content   => template('misp/bootstrap.php.erb'),
    subscribe => Exec['Directory permissions'],
  }

  file { "${misp::config_dir}/core.php":
    ensure    => file,
    owner     => $misp::default_high_user,
    group     => $misp::default_high_group,
    content   => template('misp/core.php.erb'),
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

  file{"${misp::install_dir}/app/Console/worker/start.sh":
    owner => $misp::default_high_user,
    group => $misp::default_high_group,
    mode  => '+x',
  }
}
