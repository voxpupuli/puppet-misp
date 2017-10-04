
class misp::dependencies inherits misp {

  ensure_packages( [
    'gcc', # Needed for compiling Python modules
    'git', # Needed for pulling the MISP code and those for some dependencies
    'zip', 'mariadb',
    'python-devel', 'python2-pip', 'python-lxml', 'python-dateutil', 'python-six', # Python related packages
    'libxslt-devel', 'zlib-devel',
    'rh-php56', 'rh-php56-php-fpm', 'rh-php56-php-devel', 'rh-php56-php-mysqlnd', 'rh-php56-php-mbstring', 'php-pear', 'rh-php56-php-xml', 'rh-php56-php-bcmath', # PHP related packages
    'php-mbstring', #Required for Crypt_GPG
    'haveged',
    'sclo-php56-php-pecl-redis', # Redis connection from PHP
    'php-pear-crypt-gpg', # Crypto GPG 
    'pymisp', 'python-magic', # Advance attachment handler
    'ssdeep', 'ssdeep-libs', 'ssdeep-devel', #For pydeep
  ],
    { 'ensure' => 'present' }
  )
}