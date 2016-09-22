#
# === Authors
#
# Author Name Pablo Panero (ppanero27@gmail.com)
#


class misp (
  $db_name = 'misp',
  $db_user = 'misp',
  $db_host = 'localhost',
  $db_port = '3306',
  $db_password = '',
  $misp_git_tag = 'v2.4.51',
  $stix_git_repo = 'git://github.com/STIXProject/python-stix.git',
  $stix_git_tag = 'v1.1.1.4',
  $cybox_git_repo = 'git://github.com/CybOXProject/python-cybox.git',
  $cybox_git_tag = 'v2.1.0.12',
  $salt = 'Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
  $cipherseed = '',
  $auth_method = '',
  $org_id = '1',
  $webservername = 'httpd',
  $redis_server = true,
  $email = 'root@localhost', # This address is used as sender (from) when sending notifications
  $contact = 'root@localhost', # This address is used in error messages
  $live = true,
  $site_admin_debug = false,
  $enrichment_service = false,
  $enrichment_hover = false,
  $gpg_email = 'no-reply@localhost',
  $gpg_homedir = '/var/www/MISP/',
  $import_service = true,
  $export_service = true,
  $install_dir = '/var/www/MISP/',
  $config_dir = "${install_dir}/app/Config/",
  $timezone = 'UTC',
  $default_user = 'apache',
  $default_group = 'apache',
  $default_high_user = 'root',
  $default_high_group = 'apache',
  $shib_default_org = '1',
  $egroup_role_match = {}) {

  #include ::systemd

  contain '::misp::dependencies'
  contain '::misp::install'
  contain '::misp::config'
  contain '::misp::service'
}
