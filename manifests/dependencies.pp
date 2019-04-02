
class misp::dependencies inherits misp {

  [
    'gcc', # Needed for compiling Python modules
    'git', # Needed for pulling the MISP code and those for some dependencies
    'zip',
    'libxslt-devel', 'zlib-devel',
    'ssdeep', 'ssdeep-libs', 'ssdeep-devel', #For pydeep

    # PHP packages
    "rh-${misp::php_version}", "rh-${misp::php_version}-php-fpm", "rh-${misp::php_version}-php-devel",
    "rh-${misp::php_version}-php-mysqlnd", "rh-${misp::php_version}-php-mbstring", "rh-${misp::php_version}-php-pear",
    "rh-${misp::php_version}-php-xml", "rh-${misp::php_version}-php-bcmath",

    # Redis connection from PHP
    "sclo-${misp::php_version}-php-pecl-redis4",
  ].each |String $pkg| {
    ensure_resource('package', $pkg)
  }

  if $misp::manage_python {
    ensure_packages( ['rh-python36', 'rh-python36-python-devel', 'rh-python36-python-pip', 'rh-python36-python-six'] )
  }

  if $misp::pymisp_rpm {
    ensure_resource('package', 'pymisp')
  }

  if $misp::build_lief {
    ensure_resource('package', ['devtoolset-7', 'cmake3'], {})
  }
  elsif $misp::lief {
    ensure_resource('package', $misp::lief_package_name)
  }
}
