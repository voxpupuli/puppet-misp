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
  $db_host = 'misp.com',
  $db_port = '5505',
  $git_tag='v2.4.51',
  $salt='Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
  $cipherseed='',
  $orgname = 'ORGNAME',
  $webservername = 'httpd',
  $email = 'root@localhost',
  $contact = 'root@localhost',
  $live = true,
  $site_admin_debug = false,
  $enr_service = false,
  $enr_hover = false,
  $gnu_email = 'no-reply@localhost',
  $gnu_homedir = '/var/www/html',
  $import_service = false,
  $export_service = false) {

  #certmgr::certificate { 'cert-misp': }

  include ::systemd

  firewall { '100 allow https':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  firewall { '101 allow http':
    proto  => 'tcp',
    dport  => '80',
    action => 'accept',
  }

  contain '::misp::dependencies'
  contain '::misp::install'
  contain '::misp::config'
  contain '::misp::service'
}
