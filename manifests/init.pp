#
# === Authors
#
# Author Name Pablo Panero (pablo.panero@cern.ch)
#


class misp (
  # MISP installation
  # # MISP repositories
  String $misp_git_repo = 'https://github.com/MISP/MISP.git',
  String $misp_git_tag = 'v2.4.105',
  String $stix_git_repo = 'https://github.com/STIXProject/python-stix.git',
  String $stix_git_tag = 'v1.2.0.6',
  String $cybox_git_repo = 'https://github.com/CybOXProject/python-cybox.git',
  String $cybox_git_tag = '85f975a89119e63bc2d7a67513b0f18e358c468f', # MISP requires an unreleased version
  String $mixbox_git_repo = 'https://github.com/CybOXProject/mixbox.git',
  String $mixbox_git_tag = 'v1.0.3',
  String $maec_git_repo = 'https://github.com/MAECProject/python-maec.git',
  String $maec_git_tag = 'v4.1.0.14',
  String $pydeep_git_repo = 'https://github.com/kbandla/pydeep.git',
  String $pydeep_git_tag = '60b0a00ba7f30cfa21ff92d871799685bc612cad',
  String $lief_git_repo = 'https://github.com/lief-project/LIEF.git',
  String $lief_git_tag = '0.9.0',

  String $php_version = 'php72',
  Boolean $manage_haveged = true,
  # Whether to manage Python or not. Please note that python dev needs to be
  # present in order to be able to install some of the MISP dependencies
  Boolean $manage_python = true,
  Boolean $manage_scl = true,
  Boolean $install_mariadb = true,
  Boolean $use_venv = true,
  Boolean $pymisp_rpm = false,
  Boolean $lief = false,
  Boolean $build_lief = false,
  Optional[String] $lief_package_name = undef,
  # # Services
  String $webservername = 'httpd',
  Boolean $redis_server = true,
  String $redis_service = 'redis',
  String $mariadb_service = 'rh-mariadb102-mariadb',
  Array[String] $worker_scls = ['rh-mariadb102'],

  ## MISP puppet configuration
  Stdlib::Unixpath $install_dir = '/var/www/MISP',
  Stdlib::Unixpath $config_dir = "${install_dir}/app/Config",
  Stdlib::Unixpath $venv_dir = "${install_dir}/venv",
  String $timezone = 'UTC',
  String $default_user = 'apache',
  String $default_group = 'apache',
  String $default_high_user = 'root',
  String $default_high_group = 'apache',


  ### database.php
  String $db_name = 'misp',
  String $db_user = 'misp',
  String $db_host = 'localhost',
  Integer $db_port = 3306,
  String $db_password = '',


  ### config.php
  Integer $debug = 0,
  Boolean $site_admin_debug = false,

  ## Security section
  # (critical)
  String $security_level = 'medium',
  String $security_salt = 'Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
  String $security_cipher_seed = '395786739573056621429506834955',
  Boolean $security_syslog = false,
  Boolean $security_allow_unsafe_apikey_named_param = false,
  Optional[Variant[String, Array[String]]] $security_auth_method = undef, # undef means default user-password login method
  # (recommended)
  Optional[Boolean] $security_require_password_confirmation = undef,
  Optional[Boolean] $security_sanitise_attribute_on_delete = undef,
  Optional[Boolean] $security_hide_organisation_index_from_users = undef,
  Optional[Boolean] $security_allow_cors = undef,
  Optional[String] $security_cors_origins = undef,
  # (optional)
  Optional[Integer] $security_password_policy_length = 6,
  Optional[String] $security_password_policy_complexity = '/((?=.*\\d)|(?=.*\\W+))(?![\\n])(?=.*[A-Z])(?=.*[a-z]).*$/',

  ## SecureAuth section
  # (critical)
  Integer $secure_auth_amount = 5,
  Integer $secure_auth_expire = 300,

  ## MISP section
  # (critical)
  String $baseurl = "https://${fact('networking.fqdn')}",
  String $external_baseurl = $baseurl,
  Boolean $live = true,
  String $language = 'eng',
  Boolean $enable_advanced_correlations = false,
  Variant[String,Integer] $host_org_id = '1',
  String $uuid = '0', # TODO: UUID type
  Boolean $showorg = true,
  String $email = "root@${fact('networking.fqdn')}",
  Boolean $disable_emailing = false,
  Integer[0,3] $default_event_distribution = 1,
  Variant[Integer[0,3],Enum['event']] $default_attribute_distribution = 'event',
  Array $default_event_tag_collection = [],
  Boolean $proposals_block_attributes = true,
  Boolean $completely_disable_correlation = false,
  Boolean $allow_disabling_correlation = false,
  #   Redis DB
  String $redis_host = '127.0.0.1',
  Integer[1,65535] $redis_port = 6379,
  Integer $redis_database = 13,
  Optional[String] $redis_password = undef,
  # (recommended)
  Optional[Stdlib::Unixpath] $python_bin = $use_venv ? { true => "${venv_dir}/bin/python3", false => undef },
  Optional[Boolean] $disable_auto_logout = undef,
  Optional[Integer[1,100]] $ssdeep_correlation_threshold = undef,
  Optional[Integer] $max_correlations_per_event = undef,
  Optional[Boolean] $disable_cached_exports = undef,
  Optional[String] $org = undef,
  Optional[Boolean] $background_jobs = undef,
  Optional[Boolean] $cached_attachments = undef,
  Optional[String] $contact = undef,
  Optional[Stdlib::HTTPUrl] $cveurl = undef,
  Optional[Boolean] $disablerestalert = undef,
  Optional[Boolean] $extended_alert_subject = undef,
  Optional[Integer[1,4]] $default_event_threat_level = undef,
  Optional[Boolean] $tagging = undef,
  Optional[String] $new_user_text = undef,
  Optional[String] $password_reset_text = undef,
  Optional[Boolean] $enable_event_blacklisting = undef,
  Optional[Boolean] $enable_org_blacklisting = undef,
  Optional[Boolean] $log_client_ip = undef,
  Optional[Boolean] $log_auth = undef,
  Optional[Boolean] $delegation = undef,
  Optional[Boolean] $show_correlations_on_index = undef,
  Optional[Boolean] $show_proposals_count_on_index = undef,
  Optional[Boolean] $show_sightings_count_on_index = undef,
  Optional[Boolean] $show_discussions_count_on_index = undef,
  Optional[Boolean] $disable_user_self_management = undef,
  Optional[Boolean] $block_event_alert = undef,
  Optional[String] $block_event_alert_tag = undef,
  Optional[Boolean] $block_old_event_alert = undef,
  Optional[Integer] $block_old_event_alert_age = undef,
  Optional[Stdlib::Unixpath] $tmpdir = undef,
  Optional[Boolean] $incoming_tags_disabled_by_default = undef,
  Optional[Boolean] $deadlock_avoidance = undef,
  # (optional)
  Optional[String] $maintenance_message = undef,
  Optional[String] $footermidleft = undef,
  Optional[String] $footermidright = undef,
  Optional[String] $footer_logo = undef,
  Optional[String] $home_logo = undef,
  Optional[String] $main_logo = undef,
  Optional[Boolean] $threatlevel_in_email_subject = undef,
  Optional[String] $email_subject_tlp_string = undef,
  Optional[String] $email_subject_tag = undef,
  Optional[Boolean] $email_subject_include_tag_name = undef,
  Optional[String] $attachments_dir = undef,
  Optional[Boolean] $download_attachments_on_load = undef,
  Optional[Integer[0,2]] $full_tags_on_event_index = undef,
  Optional[String] $welcome_text_top = undef,
  Optional[String] $welcome_text_bottom = undef,
  Optional[String] $welcome_logo = undef,
  Optional[String] $welcome_logo2 = undef,
  Optional[String] $title_text = undef,
  Optional[Boolean] $take_ownership_xml_import = undef,
  Optional[Boolean] $terms_download = undef,
  Optional[String] $terms_file = undef,
  Optional[Boolean] $showorgalternate = undef,
  Optional[Boolean] $unpublishedprivate = undef,
  Optional[String] $custom_css = undef,
  Optional[String] $event_view_filter_fields = undef,
  Optional[Boolean] $manage_workers = undef,

  ## GnuPG section
  # (critical)
  Boolean $gpg_onlyencrypted = false,
  String $gpg_email = 'no-reply@localhost',
  Stdlib::Unixpath $gpg_homedir = "${install_dir}/.gnupg",
  # (recommended)
  Optional[String] $gpg_password = undef,
  # (optional)
  Optional[Stdlib::Unixpath] $gpg_binary = undef,
  Optional[Boolean] $gpg_bodyonlyencrypted = undef,
  Optional[Boolean] $gpg_sign = undef,

  ## SMIME section
  # (optional)
  Optional[Boolean] $smime_enabled = undef,
  Optional[String] $smime_email = undef,
  Optional[Stdlib::Unixpath] $smime_cert_public_sign = undef,
  Optional[Stdlib::Unixpath] $smime_key_sign = undef,
  Optional[String] $smime_password = undef,

  ## Proxy section
  # (optional)
  Optional[String] $proxy_host = undef,
  Optional[Integer] $proxy_port = undef,
  Optional[Enum['Basic','Digest']] $proxy_method = undef,
  Optional[String] $proxy_user = undef,
  Optional[String] $proxy_password = undef,

  ## Session section
  # (critical)
  Boolean $session_auto_regenerate = true,
  Boolean $session_check_agent = false,
  Optional[String] $session_cookie = undef,
  Enum['php','database','cake','cache'] $session_defaults = 'php',
  Integer $session_timeout = 60,
  Integer $session_cookie_timeout = 1440,

  ## Plugins
  Integer $rpz_policy = 0,
  String $rpz_walled_garden = '127.0.0.1',
  String $rpz_serial = '$date00',
  String $rpz_refresh = '2h',
  String $rpz_retry = '30m',
  String $rpz_expiry = '30d',
  String $rpz_minimum_ttl = '1h',
  String $rpz_ttl = '1w',
  String $rpz_ns = 'localhost',
  String $rpz_ns_alt = '',
  String $rpz_email = 'root.localhost',
  Boolean $zeromq_enable = false,
  Integer $zeromq_port = 50000,
  String $zeromq_redis_host = 'localhost',
  Integer $zeromq_redis_port = 6379,
  String $zeromq_redis_password = '',
  String $zeromq_redis_database = '1',
  String $zeromq_redis_namespace = 'mispq',
  Boolean $zeromq_include_attachments = false,
  Boolean $zeromq_event_notifications_enable = false,
  Boolean $zeromq_object_notifications_enable = false,
  Boolean $zeromq_object_reference_notifications_enable = false,
  Boolean $zeromq_attribute_notifications_enable = false,
  Boolean $zeromq_tag_notifications_enable = false,
  Boolean $zeromq_audit_notifications_enable = false,
  Boolean $elasticsearch_logging_enable = false,
  String $elasticsearch_connection_string = '',
  String $elasticsearch_log_index = '',
  Boolean $syslog = false,
  Boolean $sightings_enable = false,
  Integer $sightings_policy = 0,
  Boolean $sightings_anonymise = false,
  Integer $sightings_range = 365,
  Boolean $customauth_enable = false,
  String $customauth_header = 'Authorization',
  Boolean $customauth_use_header_namespace = true,
  String $customauth_header_namespace = 'HTTP_',
  Boolean $customauth_required = false,
  String $customauth_only_allow_source = '',
  String $customauth_name = 'External authentication',
  Boolean $customauth_disable_logout = false,# TODO
  String $customauth_custom_password_reset = '',
  String $customauth_custom_logout = '',
  Boolean $enrichment_services_enable = true,
  Integer $enrichment_timeout = 10,
  Boolean $enrichment_hover_enable = true,
  Integer $enrichment_hover_timeout = 5,
  String $enrichment_services_url = 'http://127.0.0.1',
  Integer $enrichment_services_port = 6666,
  Boolean $import_services_enable = true,
  Integer $import_timeout = 10,
  String $import_services_url = 'http://127.0.0.1',
  Integer $import_services_port = 6666,
  String $export_services_url = 'http://127.0.0.1',
  Integer $export_services_port = 6666,
  Boolean $export_services_enable = true,
  Integer $export_timeout = 10,
  Boolean $cortex_services_enable = false,
  String $cortex_services_url = 'http://127.0.0.1/api',
  Integer $cortex_services_port = 9000,
  String $cortex_authkey = '',
  Integer $cortex_timeout = 120,
  Boolean $cortex_ssl_verify_peer = true,
  Boolean $cortex_ssl_verify_host = true,
  Boolean $cortex_ssl_allow_self_signed = false,
  String $cortex_ssl_cafile = '',
  # ApacheShibbAuth
  Boolean $shib_use_default_org = false,
  String $shib_default_org = '1',
  Hash $egroup_role_match = {},
) {

  contain '::misp::dependencies'
  contain '::misp::install'
  contain '::misp::config'
  contain '::misp::service'
}
