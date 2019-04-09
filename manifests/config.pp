
class misp::config inherits misp {

  require 'misp::install'

  # Apache permissions

  file { "${misp::install_dir}/app/Plugin/CakeResque/Config/config.php":
    ensure    => file,
    owner     => $misp::default_user,
    group     => $misp::default_group,
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
    recurse   => true,
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

  file {"${misp::install_dir}/app/Plugin/CakeResque/tmp":
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
    owner     => $misp::default_user,
    group     => $misp::default_group,
    content   => epp('misp/bootstrap.php.epp', { auth_method => $misp::security_auth_method }),
    subscribe => Exec['Directory permissions'],
  }

  file { "${misp::config_dir}/core.php":
    ensure    => file,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    content   => epp('misp/core.php.epp', {
        level           => $misp::security_level,
        salt            => $misp::security_salt,
        cipher_seed     => $misp::security_cipher_seed,
        auto_regenerate => $misp::session_auto_regenerate,
        check_agent     => $misp::session_check_agent,
        defaults        => $misp::session_defaults,
        timeout         => $misp::session_timeout,
        cookie_timeout  => $misp::session_cookie_timeout,
    }),
    subscribe => Exec['Directory permissions'],
  }

  file{"${misp::config_dir}/database.php":
    ensure    => file,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    mode      => '0640',
    content   => epp('misp/database.php.epp', {
        host     => $misp::db_host,
        user     => $misp::db_user,
        port     => $misp::db_port,
        password => $misp::db_password,
        db_name  => $misp::db_name,
    }),
    subscribe => Exec['Directory permissions'],
  }

  file{"${misp::config_dir}/config.php":
    ensure    => file,
    owner     => $misp::default_user,
    group     => $misp::default_group,
    mode      => '0640',
    content   => epp('misp/config.php.epp', { context => Class[misp] }),
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
}
