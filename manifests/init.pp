# == Class: misp
#
# Full description of class misp here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'misp':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#

class misp (
  $db_name = 'misp',
  $db_user = 'misp',
  $db_host = 'localhost',
  $db_port = '3306',
  $misp_git_tag='v2.4.51',
  $stix_git_repo='git://github.com/STIXProject/python-stix.git',
  $stix_git_tag='v1.1.1.4',
  $cybox_git_repo='git://github.com/CybOXProject/python-cybox.git',
  $cybox_git_tag='v2.1.0.12',
  $salt='Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
  $cipherseed='',
  $org_id = '1',
  $webservername = 'httpd',
  $email = 'root@localhost',
  $contact = 'root@localhost',
  $live = true,
  $site_admin_debug = false,
  $enrichment_service = false,
  $enrichment_hover = false,
  $gpg_email = 'no-reply@localhost',
  $gpg_homedir = '/var/www/html',
  $import_service = false,
  $export_service = false,
  $install_dir = '/var/www/MISP/',
  $config_dir = "${install_dir}/app/Config/") {

  #include ::systemd

  contain '::misp::dependencies'
  contain '::misp::install'
  contain '::misp::config'
  contain '::misp::service'
}
