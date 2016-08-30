
class misp::dependencies inherits misp {

  ensure_packages( [
    'gcc', # Needed for compiling Python modules
    'git', # Needed for pulling the MISP code and those for some dependencies
    'zip', 'redis', 'mariadb', #'httpd',# already defined by apache module
    'python-devel', 'python-pip', 'python-lxml', 'python-dateutil', 'python-six', 'python-lxml', 'python-dateutil', 'python-six', # Python related packages
    'libxslt-devel', 'zlib-devel',
    'rh-php56', 'rh-php56-php-fpm', 'rh-php56-php-devel', 'rh-php56-php-mysqlnd', 'rh-php56-php-mbstring', 'php-pecl-redis', 'php-pear',# PHP related packages
    'php-mbstring', #Required for Crypt_GPG
    'haveged',
    'mod_ssl', #Required for ssl connection
    'mod_fcgid', #Required for fcgid for php56
  ],
    { 'ensure' => 'present' }
  )

  exec { 'pear update-channels pear.php.net' :
    command => '/usr/bin/pear update-channels pear.php.net',
    require => [Package['php-pear']],
  }

  exec {'pear install Crypt_GPG':
    command => '/usr/bin/pear install Crypt_GPG',
    creates => '/usr/bin/Crypt_GPG',
    unless  => '/usr/bin/pear list | grep Crypt_GPG',
    require => Exec['pear update-channels pear.php.net'],
  }

  exec {'pip install importlib':
    command => '/usr/bin/pip install importlib',
    unless  => '/usr/bin/pip list | grep importlib',
  }
}