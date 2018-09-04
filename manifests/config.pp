
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
    command     => "/usr/bin/chown -R ${misp::default_high_user}:${misp::default_high_group} ${misp::install_dir} && /usr/bin/find ${misp::install_dir} -type d -exec /usr/bin/chmod g=rx {} \\; && /usr/bin/chmod -R g+r,o= ${misp::install_dir}",
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
    mode      => '0750',
    recurse   => true,
    seltype   => 'httpd_sys_rw_content_t',
    subscribe => Exec['Directory permissions'],
    notify    => File["${misp::install_dir}/app/tmp/logs/"],#Comment for logrotate usage
  }

  #selinux::fcontext{'tmp_fcontext' :
  #  pathname  => '/var/www/MISP/app/tmp/logs(/.*)?',
  #  filemode  => 'a',
  #  context   => 'httpd_log_t' ,
  #  subscribe => File["${misp::install_dir}/app/tmp","${misp::install_dir}/app/webroot/img/orgs", "${misp::install_dir}/app/webroot/img/custom"] ,
  #  notify    => File["${misp::install_dir}/app/tmp/logs/"],
  #}

  file {"${misp::install_dir}/app/tmp/logs/" :
    ensure  => directory,
    mode    => '0750',
    owner   => $misp::default_user,
    group   => $misp::default_group,
    recurse => true,
    #seltype => 'httpd_log_t', #Uncomment for logrotate usage
    seltype => 'httpd_sys_rw_content_t',
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

  if fact('os.selinux.enabled') {
    selboolean { 'httpd redis connection':
      name       => 'httpd_can_network_connect',
      persistent => true,
      value      => 'on',
    }

    Selboolean['httpd redis connection'] ~> Service <| title == $misp::webservername |>
  }

  file{"${misp::install_dir}/app/Console/worker/start.sh":
    owner => $misp::default_high_user,
    group => $misp::default_high_group,
    mode  => '+x',
  }
}
