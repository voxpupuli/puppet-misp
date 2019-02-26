
class misp::dependencies inherits misp {

  [
    'gcc', # Needed for compiling Python modules
    'git', # Needed for pulling the MISP code and those for some dependencies
    'zip', 'mariadb',
    'python-lxml', 'python-dateutil', 'python-six', 'python-zmq', # Python related packages
    'libxslt-devel', 'zlib-devel',
    'rh-php56', 'rh-php56-php-fpm', 'rh-php56-php-devel', 'rh-php56-php-mysqlnd', 'rh-php56-php-mbstring', 'php-pear', 'rh-php56-php-xml', 'rh-php56-php-bcmath', # PHP related packages
    'php-mbstring', #Required for Crypt_GPG
    'haveged',
    'sclo-php56-php-pecl-redis', # Redis connection from PHP
    'php-pear-crypt-gpg', # Crypto GPG
    'python-magic', # Advance attachment handler
    'ssdeep', 'ssdeep-libs', 'ssdeep-devel', #For pydeep
  ].each |String $pkg| {
    ensure_resource('package', $pkg)
  }

  if $misp::manage_python {
    class { 'python' :
      version => 'system',
      pip     => 'present',
      dev     => 'present',
    }
  }

  if $misp::pymisp_rpm {
    ensure_resource('package', 'pymisp')
  } else {
    python::pip { 'pymisp' :
      pkgname => 'pymisp',
    }
  }

  if $misp::lief {
    ensure_resource('package', $misp::lief_package_name)
  }
}
