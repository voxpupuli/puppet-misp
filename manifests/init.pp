#
# === Authors
#
# Author Name Pablo Panero (ppanero27@gmail.com)
#


class misp (
  # MISP installation
  $misp_git_tag = 'v2.4.51',
  $stix_git_repo = 'git://github.com/STIXProject/python-stix.git',
  $stix_git_tag = 'v1.1.1.4',
  $cybox_git_repo = 'git://github.com/CybOXProject/python-cybox.git',
  $cybox_git_tag = 'v2.1.0.12',
  $org_id = '1',
  $org = 'ORGNAME',
  $session_timeout = 60,
  $install_dir = '/var/www/MISP/',
  $config_dir = "${install_dir}/app/Config/",
  $timezone = 'UTC',
  $default_user = 'apache',
  $default_group = 'apache',
  $default_high_user = 'root',
  $default_high_group = 'apache',
  # database.php
  $db_name = 'misp',
  $db_user = 'misp',
  $db_host = 'localhost',
  $db_port = '3306',
  $db_password = '',
  # config.php
  $debug = 0,
  $site_admin_debug = false,
  # Security
  $security_level = 'medium',
  $salt = 'Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
  $cipherseed = '',
  $auth_method = '', # Empty means default user-password login method
  $password_policy_length = 6,
  $password_policy_complexity = '/((?=.*\\d)|(?=.*\\W+))(?![\\n])(?=.*[A-Z])(?=.*[a-z]).*$/',
  # MISP
  $footermidleft = '',
  $footermidright = '',
  $host_org_id = '1',
  $email_subject_org = 'ORGNAME',
  $showorg = true,
  $background_jobs = true,
  $cached_attachments = true,
  $email = 'root@localhost', # This address is used as sender (from) when sending notifications
  $contact = 'root@localhost', # This address is used in error messages
  $cveurl = 'http://cve.circl.lu/cve/',
  $disablerestalert = false,
  $default_event_distribution = '1',
  $default_attribute_distribution = 'event',
  $tagging = true,
  $full_tags_on_event_index = true,
  $footer_logo = '',
  $take_ownership_xml_import = false,
  $unpublishedprivate = false,
  $disable_emailing = false,
  $live = true,
  $extended_alert_subject = false,
  $default_event_threat_level = '1',
  $new_user_text = "Dear new MISP user,\\n\\nWe would hereby like to welcome you to the ${org} MISP community.\\n\\n Use the credentials below to log into MISP at ${fqdn}, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: ${username}\\nPassword: ${password}\\n\\nIf you have any questions, don\'t hesitate to contact us at: ${contact}.\\n\\nBest regards,\\nYour ${org} MISP support team",
  $password_reset_text = "Dear MISP user,\\n\\nA password reset has been triggered for your account. Use the below provided temporary password to log into MISP at ${fqdn}, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: ${username}\\nYour temporary password: ${password}\\n\\nIf you have any questions, don\'t hesitate to contact us at: ${contact}.\\n\\nBest regards,\\nYour ${org} MISP support team",
  $enable_event_black_listing = false,
  $enable_org_blacklisting = false,
  $log_client_ip = false,
  $log_auth = false,
  $disable_user_self_management = false,
  $block_old_event_alert = false,
  $block_old_event_alert_age = 30,
  $maintenance_message = "Great things are happening! MISP is undergoing maintenance, but will return shortly. You can contact the administration at ${email}.",
  $email_subject_tlp_string = 'TLP Amber',
  $terms_download = false,
  $showorgalternate = false,
  # GPG
  $gpg_onlyencrypted = false,
  $gpg_email = 'no-reply@localhost',
  $gpg_homedir = '/var/www/MISP/',
  $gpg_password = '',
  $gpg_bodyonlyencrypted = false,
  # SMIME
  $smime_enabled = false,
  $smime_email = '',
  $smime_cert_public_sign = '',
  $smime_key_sign = '',
  $smime_password = '',
  # Proxy
  $proxy_host = '',
  $proxy_port = '',
  $proxy_method = '',
  $proxy_user = '',
  $proxy_password = '',
  # SecureAuth
  $secure_auth_amount = 5,
  $secure_auth_expire = 300,
  # Plugin
  $customauth_disable_logout = true,
  $zeromq_enable = false,
  $zeromq_port = 50000,
  $zeromq_redis_host = 'localhost',
  $zeromq_redis_port = 6379,
  $zeromq_redis_password = '',
  $zeromq_redis_database = '1',
  $zeromq_redis_namespace = 'mispq',
  $rpz_policy = 0,
  $rpz_walled_garden = '127.0.0.1',
  $rpz_serial = '$date00',
  $rpz_refresh = '2h',
  $rpz_retry = '30m',
  $rpz_expiry = '30d',
  $rpz_minimum_ttl = '1h',
  $rpz_ttl = '1w',
  $rpz_ns = 'localhost',
  $rpz_email = 'root.localhost',
  $sightings_anonymise = false,
  $sightings_policy = 0,
  $sightings_enable = false,
  $export_services_enable = true,
  $export_services_url = 'http://127.0.0.1',
  $export_services_port = 6666,
  $export_timeout = 10,
  $import_services_enable = true,
  $import_services_url = 'http://127.0.0.1',
  $import_services_port = 6666,
  $import_timeout = 10,
  $enrichment_services_enable = true,
  $enrichment_services_url = 'http://127.0.0.1',
  $enrichment_services_port = 6666,
  $enrichment_timeout = 10,
  $enrichment_hover_enable = true,
  $enrichment_hover_timeout = 5,
  # ApacheShibbAuth
  $shib_default_org = '1',
  $egroup_role_match = {},
  # Services
  $webservername = 'httpd',
  $redis_server = true,) {

  contain '::misp::dependencies'
  contain '::misp::install'
  contain '::misp::config'
  contain '::misp::service'
}
