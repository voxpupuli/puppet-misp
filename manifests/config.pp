
class misp::config ($db_name = 'default', $db_user = 'default', $db_host = 'default', $db_port = 'default', $git_tag='default', $salt='default', $cipherseed='default',
  $ssl_port = 'default', $server_admin = 'deafault', $document_root = 'default', $certificate_file ='default',
  $certificate_key_file = 'default', $certificate_chain_file = 'default', $orgname = 'default') inherits misp {

  require 'misp::install'

  #Shibboleth

  class {'::shibboleth':
    application_name    => 'wlcg-misp',
    site_name           => 'wlcg-misp.cern.ch',
    remote_user_enabled => true,
    remote_user         => 'ADFS_LOGIN',
    session_storage     => 'memory',
    require_ssl         => true,
  }

  #Apache permissions

  exec {'Directory permissions':
    command => '/usr/bin/chown -R root:apache /var/www/MISP && /usr/bin/find /var/www/MISP -type d -exec /usr/bin/chmod g=rx {} \; && /usr/bin/chmod -R g+r,o= /var/www/MISP',
    refreshonly => true, #Might be a problem with updates. It will only be executed if the full installation goes through
    subscribe => File['/var/www/MISP/app/Plugin/CakeResque/Config/config.php'],
  }

  file {'/var/www/MISP/app/files' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => false,
    subscribe => Exec['Directory permissions'],
    notify => File['/var/www/MISP/app/files/terms','/var/www/MISP/app/files/scripts/tmp'],
  }

  file {'/var/www/MISP/app/files/terms' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => false,
  }

  file {'/var/www/MISP/app/files/scripts/tmp' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => false,
  }

  file {'/var/www/MISP/app/Plugin/CakeResque/tmp' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => false,
    subscribe => Exec['Directory permissions'],
  }

  file {'/var/www/MISP/app/tmp' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => true,
    subscribe => Exec['Directory permissions'],
  }

  file {'/var/www/MISP/app/webroot/img/orgs' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => true,
    subscribe => Exec['Directory permissions'],
  }

  file {'/var/www/MISP/app/webroot/img/custom' :
    ensure => directory,
    owner => 'apache',
    group => 'apache',
    recurse => true,
    subscribe => Exec['Directory permissions'],
  }

  file { '/var/www/MISP/app/Config/bootstrap.php':
    ensure => file,
    owner => 'root',
    group => 'apache',
    source => 'file:///var/www/MISP/app/Config/bootstrap.default.php',
    subscribe => Exec['Directory permissions'],
  }

  file { '/var/www/MISP/app/Config/core.php':
    ensure => file,
    owner => 'root',
    group => 'apache',
    source => 'file:///var/www/MISP/app/Config/core.default.php',
    subscribe => Exec['Directory permissions'],
  }

  teigi::secret::sub_file{'/var/www/MISP/app/Config/database.php':
    teigi_keys => ['misp_db_password'],
    template => 'misp/database.php.erb',
    subscribe => Exec['Directory permissions'],
    owner   => 'root',
    group   => 'apache',
    mode => '640',
  }


  file{'/var/www/MISP/app/Config/config.php':
    ensure => file,
    owner   => 'apache',
    group   => 'apache',
    content => template('misp/config.php.erb'),
    subscribe => Exec['Directory permissions'],
  }

  #Apache config

  file{'/etc/httpd/conf.d/misp.conf':
    ensure => file,
    owner   => 'root',
    group   => 'apache',
    content => template('misp/misp.conf.erb'),
    subscribe => Exec['Directory permissions'],
  }

  exec {'chcon files':
    command => '/usr/bin/chcon -t httpd_sys_content_rw_t /var/www/MISP/app/files',
    subscribe => File['/var/www/MISP/app/files'],
  }

  exec {'chcon files/terms':
    command => '/usr/bin/chcon -t httpd_sys_content_rw_t /var/www/MISP/app/files/terms',
    subscribe => File['/var/www/MISP/app/files/terms'],
  }

  exec {'chcon files/scripts/tmp':
    command => '/usr/bin/chcon -t httpd_sys_content_rw_t /var/www/MISP/app/files/scripts/tmp',
    subscribe => File['/var/www/MISP/app/files/scripts/tmp'],
  }

  exec {'chcon CakeResque':
    command => '/usr/bin/chcon -t httpd_sys_content_rw_t /var/www/MISP/app/Plugin/CakeResque/tmp',
    subscribe => File['/var/www/MISP/app/Plugin/CakeResque/tmp'],
  }

  exec {'chcon app/tmp':
    command => '/usr/bin/chcon -R -t httpd_sys_content_rw_t /var/www/MISP/app/tmp',
    subscribe => File['/var/www/MISP/app/tmp'],
  }

  exec {'chcon app/webroot/img/orgs':
    command => '/usr/bin/chcon -R -t httpd_sys_content_rw_t /var/www/MISP/app/webroot/img/orgs',
    subscribe => File['/var/www/MISP/app/webroot/img/orgs'],
  }

  exec {'chcon app/webroot/img/custom':
    command => '/usr/bin/chcon -R -t httpd_sys_content_rw_t /var/www/MISP/app/webroot/img/custom',
    subscribe => File['/var/www/MISP/app/webroot/img/custom'],
  }

  exec{'setsebool redis':
    command => '/usr/sbin/setsebool -P httpd_can_network_connect on',
    subscribe => File['/etc/opt/rh/rh-php56/php.d/99-redis.ini'],
  }

  exec {'restart apache':
    command => '/bin/systemctl restart  httpd.service',
    user => 'root',
    group => 'apache',
    subscribe => Exec['setsebool redis']
  }

  exec{'chcon config.php':
    command => '/usr/bin/chcon -t httpd_sys_content_rw_t /var/www/MISP/app/Config/config.php',
    subscribe => File['/var/www/MISP/app/Config/config.php'],
  }

  exec {'start bg workers':
    command => '/usr/bin/chmod +x /var/www/MISP/app/Console/worker/start.sh && /usr/bin/su -s /bin/bash apache -c \'/usr/bin/scl enable rh-php56 /var/www/MISP/app/Console/worker/start.sh\'',
    user => 'root',
    group => 'apache',
    subscribe => Exec['chcon config.php'],
  }

}