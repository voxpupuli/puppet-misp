
class misp::install inherits misp {

  require '::misp::dependencies'

  # MISP

  vcsrepo { $misp::install_dir:
    ensure     => present,
    provider   => git,
    submodules => true,
    force      => false,
    source     => $misp::misp_git_repo,
    revision   => $misp::misp_git_tag,
  }
  # To stop the diagnostics complaints in MISP
  file { "${misp::install_dir}/.git/ORIG_HEAD":
    ensure  => file,
    content => '',
    owner   => $misp::default_user,
    group   => $misp::default_group,
    seltype => 'httpd_sys_rw_content_t',
    replace => false,
    require => Vcsrepo[$misp::install_dir],
  }

  exec { 'git ignore permissions':
    command     => '/usr/bin/git config core.filemode false',
    cwd         => $misp::install_dir,
    refreshonly => true,
    subscribe   => Vcsrepo[$misp::install_dir],
    notify      => Vcsrepo["${misp::install_dir}/app/files/scripts/python-cybox","${misp::install_dir}/app/files/scripts/python-stix", "${misp::install_dir}/app/files/scripts/mixbox", "${misp::install_dir}/app/files/scripts/python-maec", "${misp::install_dir}/app/files/scripts/pydeep"],
  }


  ## Python plugins
  #

  if $misp::use_venv {
    file { $misp::venv_dir:
      ensure  => directory,
      owner   => $misp::default_user,
      group   => $misp::default_group,
      require => Vcsrepo[$misp::install_dir],
    }
    exec { 'Create MISP virtualenv':
      command => "/usr/bin/scl enable rh-python36 'python -m venv ${misp::venv_dir}'",
      creates => "${misp::venv_dir}/bin/activate",
      user    => $misp::default_user,
      require => File[$misp::venv_dir],
    }
    $pip_path = [ "${misp::venv_dir}/bin", '/usr/bin', '/bin' ]
  } else {
    $pip_path = [ '/opt/rh/rh-python36/root/usr/bin', '/opt/rh/rh-python36/root/bin', '/usr/bin', '/bin' ]
  }

  Exec <| title == 'Create MISP virtualenv' |>
  -> exec {
    default:
      umask   => '0022',
      path    => $pip_path,
      user    => $misp::default_user,
      require => Exec['Install python-cybox'];

    'Install python-dateutil':
      command => 'pip install python-dateutil',
      unless  => 'pip freeze --all | /bin/grep python-dateutil=';

    'Install python-magic':
      command => 'pip install python-magic',
      unless  => 'pip freeze --all | /bin/grep python-magic=';

    'Install enum34':
      command => 'pip install enum34',
      unless  => 'pip freeze --all | /bin/grep enum34=';

    'Install lxml':
      command => 'pip install lxml',
      unless  => 'pip freeze --all | /bin/grep lxml=';

    'Install six':
      command => 'pip install six',
      unless  => 'pip freeze --all | /bin/grep six=';

    'Install zmq':
      command => 'pip install zmq',
      unless  => 'pip freeze --all | /bin/grep zmq=';

    'Install stix2 v1.1.1':
      command => 'pip install stix2==1.1.1',
      unless  => 'pip freeze --all | /bin/grep stix2==1.1.1';
  }
  if !$misp::pymisp_rpm {
    Exec <| title == 'Create MISP virtualenv' |>
    -> exec { 'Install pymisp':
      command => 'pip install pymisp',
      unless  => 'pip freeze --all | /bin/grep pymisp=',
      umask   => '0022',
      path    => $pip_path,
      user    => $misp::default_user,
      require => Exec['Install python-cybox'],
    }
  }


  vcsrepo { "${misp::install_dir}/app/files/scripts/python-cybox":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::cybox_git_repo,
    revision => $misp::cybox_git_tag,
    owner    => $misp::default_user,
    group    => $misp::default_group,
  }

  vcsrepo { "${misp::install_dir}/app/files/scripts/python-stix":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::stix_git_repo,
    revision => $misp::stix_git_tag,
    owner    => $misp::default_user,
    group    => $misp::default_group,
  }

  vcsrepo { "${misp::install_dir}/app/files/scripts/mixbox":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::mixbox_git_repo,
    revision => $misp::mixbox_git_tag,
    owner    => $misp::default_user,
    group    => $misp::default_group,
  }

  vcsrepo { "${misp::install_dir}/app/files/scripts/python-maec":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::maec_git_repo,
    revision => $misp::maec_git_tag,
    owner    => $misp::default_user,
    group    => $misp::default_group,
  }

  vcsrepo { "${misp::install_dir}/app/files/scripts/pydeep":
    ensure   => present,
    provider => git,
    force    => false,
    source   => $misp::pydeep_git_repo,
    revision => $misp::pydeep_git_tag,
    owner    => $misp::default_user,
    group    => $misp::default_group,
  }

  if $misp::build_lief {
    vcsrepo { "${misp::install_dir}/app/files/scripts/lief":
      ensure   => present,
      owner    => $misp::default_user,
      group    => $misp::default_group,
      source   => $misp::lief_git_repo,
      revision => $misp::lief_git_tag,
      provider => git,
      force    => false,
    }

    Exec <| title == 'Create MISP virtualenv' |>
    -> exec {
      default:
        cwd  => "${misp::install_dir}/app/files/scripts/lief/build",
        user => $misp::default_user;

      'Ensure LIEF build dir':
        cwd     => '/',
        command => "/bin/mkdir '${misp::install_dir}/app/files/scripts/lief/build'",
        creates => "${misp::install_dir}/app/files/scripts/lief/build",
        require => Vcsrepo["${misp::install_dir}/app/files/scripts/lief"];

      'Set up LIEF build':
        command   => '/usr/bin/scl enable devtoolset-7 rh-python36 "bash -c \'cmake3 -DLIEF_PYTHON_API=ON -DLIEF_DOC=OFF -DLIEF_EXAMPLES=OFF -DCMAKE_BUILD_TYPE=Release -DPYTHON_VERSION=3.6 ..\'"',
        creates   => "${misp::install_dir}/app/files/scripts/lief/build/CMakeCache.txt",
        require   => Exec['Ensure LIEF build dir'],
        subscribe => Vcsrepo["${misp::install_dir}/app/files/scripts/lief"];

      'Compile LIEF':
        command   => '/usr/bin/make -j$(nproc)',
        creates   => "${misp::install_dir}/app/files/scripts/lief/build/api/python/_pylief.so",
        timeout   => 900,
        subscribe => Exec['Set up LIEF build'];

      'Uninstall faulty LIEF':
        path    => $pip_path,
        command => 'pip uninstall lief --yes',
        onlyif  => "strings ${misp::venv_dir}/lib64/python3.6/site-packages/lief-*/_pylief.*.so | grep GLIBCXX_3.4.20",
        notify  => Exec['Install LIEF'];

      'Install LIEF':
        cwd       => "${misp::install_dir}/app/files/scripts/lief/build/api/python",
        path      => $pip_path,
        command   => 'python3 setup.py install',
        unless    => 'pip freeze --all | /bin/grep lief=',
        subscribe => Exec['Compile LIEF'];
    }
  }

  Exec <| title == 'Create MISP virtualenv' |>
  -> exec {
    default:
      command => '/usr/bin/git config core.filemode false && python3 setup.py install',
      path    => $pip_path,
      user    => $misp::default_user,
      umask   => '0022';

    'Uninstall old cybox':
      command => 'pip uninstall cybox --yes',
      onlyif  => 'pip freeze | /bin/grep cybox==2.1.0.13';

    'Install python-cybox':
      cwd       => "${misp::install_dir}/app/files/scripts/python-cybox/",
      unless    => 'pip freeze | /bin/grep cybox=',
      subscribe => Vcsrepo["${misp::install_dir}/app/files/scripts/python-cybox"];

    'Install python-stix':
      cwd       => "${misp::install_dir}/app/files/scripts/python-stix/",
      unless    => 'pip freeze | /bin/grep stix=',
      subscribe => Vcsrepo["${misp::install_dir}/app/files/scripts/python-stix"];

    'Install mixbox':
      cwd       => "${misp::install_dir}/app/files/scripts/mixbox/",
      unless    => 'pip freeze | /bin/grep mixbox=',
      subscribe => Vcsrepo["${misp::install_dir}/app/files/scripts/mixbox"];

    'Install python-maec':
      cwd       => "${misp::install_dir}/app/files/scripts/python-maec/",
      unless    => 'pip freeze | /bin/grep maec=',
      subscribe => Vcsrepo["${misp::install_dir}/app/files/scripts/python-maec"];

    'Install pydeep':
      command   => 'python3 setup.py build && python3 setup.py install',
      cwd       => "${misp::install_dir}/app/files/scripts/pydeep/",
      unless    => 'pip freeze | /bin/grep pydeep=',
      subscribe => Vcsrepo["${misp::install_dir}/app/files/scripts/pydeep"];
  }


  ## Pears
  #

  $run_php = "/usr/bin/scl enable rh-${misp::php_version}"

  exec {
    default:
      cwd => "${misp::install_dir}/";

    'Pear install Console_CommandLine':
      creates => "/opt/rh/rh-${misp::php_version}/root/usr/share/pear/Console/CommandLine.php",
      command => "${run_php} 'pear install ${misp::install_dir}/INSTALL/dependencies/Console_CommandLine/package.xml'";

    'Pear install Crypt_GPG':
      creates => "/opt/rh/rh-${misp::php_version}/root/usr/share/pear/Crypt/GPG.php",
      command => "${run_php} 'pear install ${misp::install_dir}/INSTALL/dependencies/Crypt_GPG/package.xml'";
  }


  ## CakePHP
  #

  # Fix a bug in the CentOS packaging, apache is expected to be from rh-httpd24
  User <| title == 'apache' |> {
    home => '/usr/share/httpd'
  }

  file {
    default:
      ensure => directory,
      owner  => $misp::default_user,
      group  => $misp::default_group;

    '/usr/share/httpd/.composer':;
    "${misp::install_dir}/app/Plugin/CakeResque":;
    "${misp::install_dir}/app/cache":
      seltype => 'httpd_sys_rw_content_t';
    "${misp::install_dir}/app/vendor":;
  }
  file { "${misp::install_dir}/app/Vendor":
    ensure => link,
    target => "${misp::install_dir}/app/vendor",
  }

  file {
    default:
      ensure  => file,
      content => '{}',
      owner   => $misp::default_user,
      group   => $misp::default_group,
      replace => false;

    "${misp::install_dir}/app/composer.json":;
    "${misp::install_dir}/app/composer.lock":;
  }

  exec {
    default:
      cwd         => "${misp::install_dir}/app/",
      environment => ["COMPOSER_HOME=${misp::install_dir}/app/"],
      user        => $misp::default_user,
      require     => File["${misp::install_dir}/app/composer.json","${misp::install_dir}/app/composer.lock"],
      refreshonly => true;

    'CakeResque require':
      command     => "${run_php} 'php composer.phar require kamisama/cake-resque:4.1.2'",
      creates     => "${misp::install_dir}/app/Plugin/CakeResque/Gruntfile.js",
      refreshonly => false,
      require     => File["${misp::install_dir}/app/cache"],
      subscribe   => Exec['git ignore permissions'],
      notify      => Exec['CakeResque config'];

    'CakeResque config':
      command => "${run_php} 'php composer.phar config vendor-dir Vendor'",
      notify  => Exec['CakeResque install'];

    'CakeResque install':
      command => "${run_php} 'php composer.phar install'",
      notify  => File["/etc/opt/rh/rh-${misp::php_version}/php-fpm.d/timezone.ini"];
  }

  ## PHP configuration
  #

  file { "/etc/opt/rh/rh-${misp::php_version}/php-fpm.d/timezone.ini":
    ensure  => file,
    content => "date.timezone = '${misp::timezone}'",
  }

  file { "/etc/opt/rh/rh-${misp::php_version}/php.d/99-timezone.ini":
    ensure    => link,
    target    => "/etc/opt/rh/rh-${misp::php_version}/php-fpm.d/timezone.ini",
    subscribe => File["/etc/opt/rh/rh-${misp::php_version}/php-fpm.d/timezone.ini"],
  }


  ## File creation for managing workers
  #

  file { '/etc/systemd/system/misp-workers.service':
    ensure  => file,
    content => epp('misp/misp-workers.service.epp', {
        install_dir => $misp::install_dir,
        user        => $misp::default_user,
        group       => $misp::default_group,
        php_version => $misp::php_version,
        services    => [$misp::mariadb_service, $misp::redis_service],
        scls        => $misp::worker_scls,
    }),
    notify  => Service['misp-workers'],
  }

  file{"${misp::install_dir}/app/Console/worker/start.sh":
    owner => $misp::default_high_user,
    group => $misp::default_high_group,
    mode  => '+x',
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
