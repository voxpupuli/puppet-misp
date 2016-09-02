
class misp::dependencies inherits misp {

  ensure_packages( [
    'gcc', # Needed for compiling Python modules
    'git', # Needed for pulling the MISP code and those for some dependencies
    'zip', 'redis', 'mariadb',
    'python-devel', 'python-pip', 'python-lxml', 'python-dateutil', 'python-six', # Python related packages
    'libxslt-devel', 'zlib-devel',
    'rh-php56', 'rh-php56-php-fpm', 'rh-php56-php-devel', 'rh-php56-php-mysqlnd', 'rh-php56-php-mbstring', 'php-pear',# PHP related packages
    'php-mbstring', #Required for Crypt_GPG
    'haveged',
  ],
    { 'ensure' => 'present' }
  )

  exec {'php56 redis': # Needed to install redis for php 5.6; php-pecl-redis installs it for php 5.4
    command => '/usr/bin/scl enable rh-php56  "pecl install redis-2.2.8"',
    unless  => '/usr/bin/scl enable rh-php56  "pecl list | grep redis"',
  }
  exec { 'pear update-channels pear.php.net' :
    command => '/usr/bin/pear update-channels pear.php.net',
    require => [Package['php-pear']],
  }

  exec {'Crypt_GPG':
    user    => root,
    command => '/usr/bin/scl enable rh-php56 "pear install Crypt_GPG"',
    creates => '/usr/bin/Crypt_GPG',
    unless  => '/usr/bin/scl enable rh-php56 "pear list | grep Crypt_GPG"',
    require => Exec['pear update-channels pear.php.net'],
  }

  exec {'pip install importlib':
    command => '/usr/bin/pip install importlib',
    unless  => '/usr/bin/pip list | grep importlib',
  }
}