# MISP MODULE

[![Build Status](https://travis-ci.org/voxpupuli/puppet-misp.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-misp)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-misp/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-misp)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/misp.svg)](https://forge.puppetlabs.com/puppet/misp)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/misp.svg)](https://forge.puppetlabs.com/puppet/misp)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/misp.svg)](https://forge.puppetlabs.com/puppet/misp)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/misp.svg)](https://forge.puppetlabs.com/puppet/misp)

#### Table of Contents

- [MISP MODULE](#misp-module)
      - [Table of Contents](#table-of-contents)
  - [Module Description](#module-description)
  - [Setup](#setup)
    - [What MISP affects](#what-misp-affects)
  - [Usage](#usage)
    - [Basic usage](#basic-usage)
    - [Another usage example](#another-usage-example)
  - [Parameters of the MIPS Class](#parameters-of-the-mips-class)
    - [MISP installation](#misp-installation)
    - [Database configuration](#database-configuration)
      - [Redis](#redis)
    - [MISP configuration](#misp-configuration)
      - [Site Configuration](#site-configuration)
      - [Security](#security)
      - [MISP](#misp)
      - [GPG](#gpg)
      - [SMIME](#smime)
      - [Proxy](#proxy)
      - [SecureAuth](#secureauth)
      - [Session](#session)
      - [Plugin](#plugin)
      - [ApacheShibbAuth](#apacheshibbauth)
    - [Services](#services)
    - [GnuPG](#gnupg)


This module installs and configures MISP (Malware Information Sharing Platform) on CentOS 7.
It has been tested on Puppet 3.8.7 and with MISP versions 2.4.50 and 2.4.51.

## Module Description

This module installs and configures MISP on CentOS 7. It installs all the needed dependencies, configures MISP and
starts the services. However it does not set up the database nor the GPG key, that is up to the administrator to do.
In addition it does not set up the web server on top of which MISP would run, meaning that Apache, Nginx or another
web server of your choice would be needed (nevertheless the module need to know to know the name of the service of the
web server (e.g. httpd)).

As mentioned before the database would need to be set up, the schema imported and then a user with rights to access the
'misp' database created. If GPG would be used, the GPG key would need to be created and placed in the configured
directory (by default '/var/www/MISP/').

The module follows the installation instructions that can be found [here](https://github.com/MISP/MISP/tree/2.4/INSTALL).
Also details about the database and GPG key creation and set up can be found there.

NOTE: the configuration and database files of MISP are used as templates on the module, therefore if the are major
changes on the version of MISP the template might cause troubles and need to be updated.

## Setup

### What MISP affects

The MISP module will not alter any OS files, all the configuration will happen in '/config_dir/' (by default
/install_dir/app/Config/') where the *core.php*, *bootstrap.php*, *database.php* and *config.php* files will be deployed
with the established values.

This module needs the following packages:

    * gcc: Needed for compiling Python modules
    * git: Needed for pulling the MISP code and other git repositories which MISP depends on
    * zip, redis, haveged and maria db
    * python-devel, python2-pip, python-lxml, python-dateutil, python-six,: Python related packages
    * rh-php56, rh-php56-php-fpm, rh-php56-php-devel, rh-php56-php-mysqlnd, rh-php56-php-mbstring, php-pecl-redis, php-pear: PHP 5.6 related packages
    * php-mbstring, php-pear-crypt-gpg: Python package required by Crypt_GPG
    * sclo-php56-php-pecl-redis: Redis related packages
    * libxslt-devel', 'zlib-devel
    * haveged

The services needed by MISP are:

    * rh-php56-php-fpm
    * haveged
    * redis: This package installs the redis server, therefore it would only be installed if the 'redis' parameter is
    set to true.
    * The 4 workers and the scheduler [CakeResque]

## Usage

### Basic usage

In order to use the module it would be enough to include the module:
```puppet
include misp,
```

Or the class:
```puppet
class{ misp:}
```

And the module will use all parameters with default values, these values are specified later on.

### Another usage example

```puppet
class {'misp':
    git_tag          => 'v2.4.67',
    email            => 'someone.someother@somewhere.ch',
    contact          => 'someone.someother@somewhere.ch',
    salt             => 'Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
    cipherseed       => '9999999999999999999999999999999999999999999999999999999999999999',
  }

```

## Parameters of the MIPS Class

The MISP class can take many parameters to change the configuration of MISP. However, they all have the default value
set to the recommended value so there is no need to change it. The parameters can be classified in the ones needed for
the installation of MISP itself, for the database, for the configuration and for the services. The parameters are the following:

### MISP installation

* `misp_git_repo` - Git url of MISP. By default "https://github.com/MISP/MISP.git".
* `misp_git_tag` - Version of MISP that will be installed. By default "v2.4.71".
* `install_dir` - Directory in which MISP will be installed. By default "/var/www/MISP/".
* `config_dir` - Directory in which the configuration of MISP should be located. By default "/var/www/MISP/app/Config/".
* `stix_git_repo`- Git url of the STIX module. By default "https://github.com/STIXProject/python-stix.git".
* `stix_git_tag`- Version of the STIX module. By default "v1.1.1.4".
* `cybox_git_repo`- Git url of the CyBox repository. By default "https://github.com/CybOXProject/python-cybox.git".
* `cybox_git_tag`- Version of the CyBox module. By default "v2.1.0.12".
* `timezone`- Timezone where the instance has been placed. By default "UTC".
* `default_user`- User as which to run the installation of MISP. By default apache.
* `default_group`- Group as which to run the installation of MISP. By default apache.
* `default_high_user`- In some cases root permissions are need in the installation, this user will be used in
those cases. By default root.
* `default_high_group`- In some cases root permissions are need in the installation, this group will be used in
those cases. By default apache.
* `uuid` - The MISP instance UUID. This UUID is used to identify this instance. By default set to 0.
* `manage_python` - Whether to manage python or not. Please note that python dev needs to be present in order to be able to install some of the MISP dependencies.
* `pymisp_rpm` - Boolean to indicate if pymisp should be installed or not (The RPM needs to be available for the machine). By default is set to false.
* `lief` - Boolean to indicate if lief should be installed or not (The RPM needs to be available for the machine). By default is set to false.
* `lief_package_name` - String containing the package name for lief.

### Database configuration

* `db_name` - Name of the database. By default "misp".
* `db_user` - Name of the user with rights on the database. By defeault "misp".
* `db_host` - Name of the host in which the database is located. By default "localhost".
* `db_port` - Port to connect to the database in the specified host. By default 3306.
* `db_password` - Password used to access the database. By default is empty.

This module does not install the MariaDB server. However, if that was needed it could be done, in your manifest, in a similar manner as the following puppet fragment:

```puppet
  $mysql_passwd = mysql_password('mispdb')

  class {'mariadb::server':
    root_password => 'mispdb',
    users                         => {
      'misp@localhost' => {
        ensure                   => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour     => '0',
        max_updates_per_hour     => '0',
        max_user_connections     => '0',
        password_hash            => $mysql_passwd,
        tls_options              => ['NONE'],
      },
    },
    grants => {
      'misp@localhost/misp.*' => {
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => 'misp.*',
        user       => 'misp@localhost',
      },
      'misp@localhost/*.*' => {
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['USAGE'],
        table      => '*.*',
        user       => 'misp@localhost',
        options    => "IDENTIFIED BY ${$mysql_passwd}",
      },
    },
    databases   => {
      'misp'  => {
        ensure  => 'present',
        charset => 'utf8',
      },
    },
  }
```

Note that it requires the edestecd-mariadb module.

#### Redis
* `redis_host` -    The host running the redis server to be used for generic MISP tasks such as caching. This is not to be confused by the redis server used by the background processing.. By default set to localhost ('127.0.01').
* `redis_port` -    The port used by the redis server to be used for generic MISP tasks such as caching. This is not to be confused by the redis server used by the background processing.. By default set to 6379.
* `redis_database` - The database on the redis server to be used for generic MISP tasks. If you run more than one MISP instance, please make sure to use a different database on each instance.. By default set to 13.

### MISP configuration

#### Site Configuration
* `debug` - Debug mode for the full instance. By default set to 0 (false).
* `site_admin_debug` - The debug level of the instance for site admins. This feature allows site admins to run debug mode on a live instance
without exposing it to other users. The most verbose option of debug and site_admin_debug is used for site admins.
By default false.

These two parameters are recommended to be set to 0 and false respectively. However, if needed they can be set to tru to find
errors with names/tables in the database. In this case it would be better to just set to true 'site_admin_debug' instead of
the whole instance.

#### Security
* `security_level` = 'medium'
* `salt` - The salt used for the hashed passwords. Keep in mind, this will invalidate all passwords in the database.
By default set to "Rooraenietu8Eeyo<Qu2eeNfterd-dd+".
* `cipherseed` - Seed for the cipher. Empty by default.
* `auth_method` - Authentication method used for the instance. Empty means default user-password login method. Empty by default.
* `password_policy_length` - Password length requirement. By default set to 6.
* `password_policy_complexity` - Password complexity requirement. By default set to '/((?=.*\\d)|(?=.*\\W+))(?![\\n])(?=.*[A-Z])(?=.*[a-z]).*$/'.
* `sanitise_attribute_on_delete` - Enabling this setting will sanitise the contents of an attribute on a soft delete. By default set to false.
* `hide_organisation_index_from_users` - Enabling this setting will block the organisation index from being visible to anyone besides site administrators on the current instance. Keep in mind that users can still see organisations that produce data via events, proposals, event history log entries, etc. By default is set to false.

#### MISP
* `live` - If set to false the instance will only be accessible by site admins. By default true.
* `language` - The language MISP should use. The default is english.
* `enable_advanced_correlations` - Enable some performance heavy correlations (currently CIDR correlation). By default false.
* `max_correlations_per_event` - Sets the maximum number of correlations that can be fetched with a single event. For extreme edge cases this can prevent memory issues. The default value is 5000.
* `maintenance_message` - The message that users will see if the instance is not live. By default set to 'Great things are happening! MISP is undergoing maintenance,
but will return shortly. You can contact the administration at \\$email.'.
* `footermidleft` - Footer text prepending the "Powered by MISP" text. Empty by default.
* `footermidright` - Footer text following the "Powered by MISP" text. Empty by default.
* `footer_logo` - This setting allows you to display a logo on the right side of the footer. Empty by default.
* `home_logo` - If set, this setting allows you to display a logo as the home icon. Upload it as a custom image in the file management tool.
Empty by default.
* `main_logo` - If set, the image specified here will replace the main MISP logo on the login screen. Upload it as a custom image in the file
management tool. Empty by default.
* `org` - The organisation tag of the hosting organisation. This is used in the e-mail subjects. By defualt set to 'ORGNAME'.
* `host_org_id` - The hosting organisation of this instance. If this is not selected then replication instances cannot be added.
By default is set to 1, meaning the first Organisation in the system.
* `showorg` - Setting this setting to 'false' will hide all organisation names / logos. By default set to true.
* `extended_alert_subject` - Enabling this flag will allow the event description to be transmitted in the alert e-mail's subject.
By default set to true.
* `threatlevel_in_email_subject` - Put the event threat level in the notification E-mail subject. By default set to true.
* `email_subject_tlp_string` - This is the TLP string in alert e-mail sent when an event is published. By default 'TLP Amber'.
* `email_subject_tag` - If this tag is set on an event it's value will be sent in the E-mail subject. If the tag is not set the email_subject_TLP_string
will be used. By default set to 'tlp'.
* `email_subject_include_tag_name` - Include in name of the email_subject_tag in the subject. When false only the tag value is used.
By default set to false.
* `email` - The e-mail address that MISP should use for all notifications. By default "root@localhost".
* `disable_emailing` - When enabled, no outgoing e-mails will be sent by MISP. By default set to false.
* `cached_attachments` - Allow the XML caches to include the encoded attachments. By default set to true.
* `download_attachments_on_load` - Always download attachments when loaded by a user in a browser.
* `contact` - The e-mail address that MISP should include as a contact address for the instance's support team. By default "root@localhost"
* `background_jobs` - Enables the use of MISP's background processing. By default set to true.
* `cveurl` - Turn Vulnerability type attributes into links linking to the provided CVE lookup. By default set to 'http://cve.circl.lu/cve/',
* `disablerestalert` - When enabled notification e-mails will not be sent when an event is created via the REST interface.
By defualt set to false.
* `default_event_distribution` - The default distribution setting for events (0-3). 0 meanse your organisation only, 1 means this
community only, 2 means contacted communities and 3 is all communities. By default set to 1.
* `default_attribute_distribution` - The default distribution setting for attributes, set it to 'event' if you would like
the attributes to default to the event distribution level. (0-3 or "event"). By default set to 'event'.
* `default_event_threat_level` - The default threat level setting when creating events. By default set to 1.
* `tagging` - Enable the tagging feature of MISP. By default set to true.
* `full_tags_on_event_index` - Show the full tag names on the event index. By default set to true.
* `welcome_text_top` - Used on the login page, before the MISP logo. Empty by default.
* `welcome_text_bottom` -   Used on the login page, after the MISP logo. Empty by default.
* `welcome_logo` - Used on the login page, to the left of the MISP logo, upload it as a custom image in the file management tool. Empty by default.
* `welcome_logo2` - Used on the login page, to the right of the MISP logo, upload it as a custom image in the file management tool. Empty by default.
* `title_text` - Used in the page title, after the name of the page. By default is set to 'MISP'.
* `take_ownership_xml_import` - Allows users to take ownership of an event uploaded via the "Add MISP XML" button.
By default set to false.
* `terms_download` - Choose whether the terms and conditions should be displayed inline (false) or offered as a
download (true). By default set to false.
* `terms_file` - The filename of the terms and conditions file. Make sure that the file is located in your MISP/app/files/terms directory. Empty by default.
* `showorgalternate` - True enables the alternate org fields for the event index (source org and member org) instead of
the traditional way of showing only an org field. By default set to false.
* `unpublishedprivate` - True will deny access to unpublished events to users outside the organization of the submitter
except site admins. By default set to false.
* `new_user_text` - The message sent to the user after an account creation. By default set to 'Dear new MISP user,\\n\\nWe would hereby like to welcome you to the \\$org MISP community.\\n\\n Use the credentials below to log into MISP at \\$misp, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: \\$username\\nPassword: \\$password\\n\\nIf you have any questions, don\'t hesitate to contact us at: \\$contact.\\n\\nBest regards,\\nYour \\$org MISP support team'.
* `password_reset_text` - The message sent to the users when a password reset is triggered. By default set to 'Dear MISP user,\\n\\nA password reset has been triggered for your account. Use the below provided temporary password to log into MISP at \\$misp, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: \\$username\\nYour temporary password: \\$password\\n\\nIf you have any questions, don\'t hesitate to contact us at: \\$contact.\\n\\nBest regards,\\nYour \\$org MISP support team'.
* `enable_event_blacklisting` - Enable the blacklisting of event UUIDs to prevent them from being pushed to your instance.
By default set to true.
* `enable_org_blacklisting` - Enable blacklisting of organisation UUIDs to prevent them from creating events.
By default set to true.
* `log_client_ip` - All log entries will include the IP address of the user. By default set to true.
* `log_auth` - MISP will log all successful authentications using API keys. By default set to false.
* `mangle_push_to_23` - When enabled, your 2.4+ instance can push events to MISP 2.3 installations. This is highly advised against and will result in degraded events
and lost information. Use this at your own risk. By default set to false.
* `delegation` - This feature allows users to created org only events and ask another organisation to take owenership of the event. This allows organisations
to remain anonymous by asking a partner to publish an event for them. By default set to false.
* `enable_advanced_correlations` - Enable some performance heavy correlations (currently CIDR correlation). By default set to false.
* `ssdeep_correlation_threshold` - Set the ssdeep score at which to consider two ssdeep hashes as correlating [1-100].
* `show_correlations_on_index` - When enabled, the number of correlations visible to the currently logged in user will be visible on the event index UI.
This comes at a performance cost but can be very useful to see correlating events at a glance. By default set to false.
* `show_proposals_count_on_index` - When enabled, the number of proposals for the events are shown on the index. By default set to false.
* `show_sightings_count_on_index` - When enabled, the aggregate number of attribute sightings within the event becomes visible to the currently logged
in user on the event index UI. By default set to false.
* `show_discussions_count_on_index` - When enabled, the aggregate number of discussion posts for the event becomes visible to the currently logged in user on
the event index UI. By default set to false.
* `disable_user_self_management` - When enabled only Org and Site admins can edit a user's profile. By default set to false.
* `block_event_alert` - Enable this setting to start blocking alert e-mails for events with a certain tag. Define the tag in MISP.block_event_alert_tag.
By default set to false.
* `block_event_alert_tag` - If the MISP.block_event_alert setting is set, alert e-mails for events tagged with the tag defined by this setting will be blocked.
By default set to 'no-alerts="true"'.
* `block_old_event_alert` - Enable this setting to start blocking alert e-mails for old events. By default set to false.
* `block_old_event_alert_age` - This setting will control how old an event can be for it to be alerted on, measured in days.
By default set to 30.
* `rh_shell_fix` - If you are running CentOS or RHEL using SCL and are having issues with the Background workers not responding to start/stop/restarts
via the worker interface, enable this setting. This will pre-pend the shell execution commands with the default path to rh-php56
(/opt/rh/rh-php56/root/usr/bin:/opt/rh/rh-php56/root/usr/sbin). By default set to false.
* `rh_shell_fix_path` - If you have rh_shell_fix enabled, the default PATH for rh-php56 is added (/opt/rh/rh-php56/root/usr/bin:/opt/rh/rh-php56/root/usr/sbin).
If you prefer to use a different path, you can set it here. By default set to '/opt/rh/rh-php56/root/usr/bin:/opt/rh/rh-php56/root/usr/sbin'
* `tmpdir` - Please indicate the temp directory you wish to use for certain functionalities in MISP. By default this is set to /tmp and will be used among others
to store certain temporary files extracted from imports during the import process.
* `custom_css` - If you would like to customise the css, simply drop a css file in the /var/www/MISP/webroot/css directory and enter the name here. Empty by default.
* `proposals_block_attributes` - Enable this setting to allow blocking attributes from to_ids sensitive exports if a proposal has been made to it to remove the
IDS flag or to remove the attribute altogether. This is a powerful tool to deal with false-positives efficiently. By default set to true.
* `incoming_tags_disabled_by_default` - Enable this settings if new tags synced / added via incoming events from any source should not be selectable by users by default.
By default set to false.
* `completely_disable_correlation` - *WARNING* This setting will completely disable the correlation on this instance and remove any existing saved correlations.
Enabling this will trigger a full recorrelation of all data which is an extremely long and costly procedure. Only enable this if you know what you're doing.
By default set to false.
* `allow_disabling_correlation` - *WARNING* This setting will give event creators the possibility to disable the correlation of individual events / attributes that they have created.
By default set to false.
* `event_view_filter_fields`* - Specify which fields to filter on when you search on the event view. Default values are : "id, uuid, value, comment, type, category, Tag.name"
* `manage_workers`* - Set this to false if you would like to disable MISP managing its own worker processes (for example, if you are managing the workers with a systemd unit).
* `deadlock_avoidance`* - Only enable this if you have some tools using MISP with extreme high concurency. General performance will be lower as normal as certain transactional queries are avoided in favour of shorter table locks.
* `allow_unsafe_apikey_named_param`* - Allows passing the API key via the named url parameter "apikey" - highly recommended not to enable this, but if you have some dodgy legacy tools that cannot pass the authorization header it can work as a workaround. Again, only use this as a last resort.

#### GPG
* `gpg_binary` - The location of the GPG executable. If you would like to use a different gpg executable than /usr/bin/gpg, you can set it here. If the default is fine,
just keep the setting suggested by MISP. By default set to '/usr/bin/gpg'
* `gpg_onlyencrypted` - Allow (false) unencrypted e-mails to be sent to users that don't have a PGP key.
By default set to false.
* `gpg_email` - The e-mail address that the instance's PGP key is tied to. By default "no-reply@localhost".
* `gpg_homedir` - The location of the GPG homedir. By default "/var/www/MISP/.gnupg".
* `gpg_password` - The password (if it is set) of the PGP key of the instance. Empty by default.
* `gpg_bodyonlyencrypted` - Allow (false) the body of unencrypted e-mails to contain details about the event.
By default set to false.

#### SMIME
* `smime_enabled` - Enable SMIME encryption. By default set to false.
* `smime_email` - The e-mail address that the instance's SMIME key is tied to. Empty by default.
* `smime_cert_public_sign` - The location of the public half of the signing certificate. Empty by default.
* `smime_key_sign` - The location of the private half of the signing certificate. Empty by default.
* `smime_password` - The password (if it is set) of the SMIME key of the instance. Empty by default.

#### Proxy
* `proxy_host` - The hostname of an HTTP proxy for outgoing sync requests. Leave empty to not use a proxy. Empty by default.
* `proxy_port` - The TCP port for the HTTP proxy. Empty by default.
* `proxy_method` - The authentication method for the HTTP proxy. Currently supported are Basic or Digest. Empty by default.
* `proxy_user` - The authentication username for the HTTP proxy. Empty by default.
* `proxy_password` - The authentication password for the HTTP proxy. Empty by default.

#### SecureAuth
* `secure_auth_amount` - The number of tries a user can try to login and fail before the bruteforce protection kicks in.
By default set to 5.
* `secure_auth_expire` - The duration (in seconds) of how long the user will be locked out when the allowed number of login
attempts are exhausted. By default set to 300.

#### Session
* `session_auto_regenerate` - Set to true to automatically regenerate sessions on activity. (Recommended).
* `session_check_agent` - In case it's set to true checks for the user agent string in each request. This can lead to occasional logouts (not recommended).
* `session_defaults` - The session type used by MISP. The default setting is php, which will use the session settings configured in php.ini for the session
data (supported options: php, database). The recommended option is php and setting your PHP up to use redis sessions via your php.ini. Just add 'session.save_handler = redis'
and "session.save_path = 'tcp://localhost:6379'" (replace the latter with your redis connection) to. By default set to 'php'.
* `session_timeout` - The timeout duration of sessions (in MINUTES). Keep in mind that autoregenerate can be used to extend the session on user activity.
By default set to 60.
* `session_cookie_timeout` - The expiration of the cookie (in MINUTES). The session timeout gets refreshed frequently, however the cookies do not. Generally it is recommended to have a much higher cookie_timeout than timeout.

#### Plugin
* `rpz_policy` - The default policy action for the values added to the RPZ. 0 means DROP, 1 NXDOMAIN, 2 NODATA and 3 walled-garden.
By default set to 0.
* `rpz_walled_garden` - The default walled garden used by the RPZ export. By default set to '127.0.0.1'.
* `rpz_serial` - The serial in the SOA portion of the zone file. By default set to '$date00'.
* `rpz_refresh` - The refresh specified in the SOA portion of the zone file. By default set to '2h'.
* `rpz_retry` - The retry specified in the SOA portion of the zone file. By default set to '30m'.
* `rpz_expiry` - The expiry specified in the SOA portion of the zone file. By default set to '30d'.
* `rpz_minimum_ttl` - The minimum TTL specified in the SOA portion of the zone file. By default set to '1h'.
* `rpz_ttl` - The TTL of the zone file. By default set to '1w'.
* `rpz_ns_alt` - Alternate nameserver. By default is empty.
* `rpz_ns` - The RPZ ns. By default set to 'localhost'.
* `rpz_email` - The e-mail address specified in the SOA portion of the zone file. By default set to 'root.localhost'.
* `zeromq_enable` - Enables or disables the pub/sub feature of MISP. By default set to false.
* `zeromq_port` - The port that the pub/sub feature will use. By default set to 50000.
* `zeromq_redis_host`- Location of the Redis db used by MISP and the Python PUB script to queue data to be published.
By default set to 'localhost'.
* `zeromq_redis_port` - The port that Redis is listening on. By default set to 6379.
* `zeromq_redis_password` - The password, if set for Redis. Emtpy by default.
* `zeromq_redis_database` - The database to be used for queuing messages for the pub/sub functionality. By default set to '1'.
* `zeromq_redis_namespace` - The namespace to be used for queuing messages for the pub/sub functionality. By default
set to 'mispq'.
* `zeromq_include_attachments` - Enable this setting to include the base64 encoded payloads of malware-samples/attachments in the output.
* `zeromq_event_notifications_enable` - Enables or disables the publishing of any event creations/edits/deletions. By default is set to false.
* `zeromq_object_notifications_enable` - Enables or disables the publishing of any object creations/edits/deletions. By default is set to false.
* `zeromq_object_reference_notifications_enable` - Enables or disables the publishing of any object reference creations/deletions. By default is set to false.
* `zeromq_attribute_notifications_enable` - Enables or disables the publishing of any attribute creations/edits/soft deletions. By default is set to false.
* `zeromq_tag_notifications_enable` - Enables or disables the publishing of any tag creations/edits/deletions as well as tags being attached to / detached from various MISP elements.
* `zeromq_audit_notifications_enable` - Enables or disables the publishing of log entries to the ZMQ pubsub feed. Keep in mind, this can get pretty verbose depending on your logging settings. By default its set to false.
* `elasticsearch_logging_enable` - Enabling logging to an ElasticSearch instance
* `elasticsearch_connection_string` - The URL(s) at which to access ElasticSearch - comma separate if you want to have more than one.
* `elasticsearch_log_index` - The index in which to place logs
* `syslog` - Enable this setting to pass all audit log entries directly to syslog. Keep in mind, this is verbose and will include user, organisation, event data. By default is set to false.
* `sightings_anonymise` - Enabling the anonymisation of sightings will simply aggregate all sightings instead of showing
the organisations that have reported a sighting. By default set to false.
* `sightings_policy` - This setting defines who will have access to seeing the reported sightings. 0 means event owner,
1 event owner and sighting reporter and 2 means everyone. By default set to 0.
* `sightings_enable` - When enabled, users can use the UI or the appropriate APIs to submit sightings data about indicators.
By default set to false.
* `sightings_range` - Set the range in which sightings will be taken into account when generating graphs. For example a sighting with a sighted_date of 7
years ago might not be relevant anymore. Setting given in number of days, default is 365 days.
* `customauth_enable` - Enable this functionality if you would like to handle the authentication via an external tool and authenticate with MISP using a custom header.
By default set to false.
* `customauth_header` - Set the header that MISP should look for here. If left empty it will default to the Authorization header. By default set to 'Authorization'.
* `customauth_use_header_namespace` - Use a header namespace for the auth header - default setting is enabled.
* `customauth_required` -   If this setting is enabled then the only way to authenticate will be using the custom header. Altnertatively you can run in mixed mode
that will log users in via the header if found, otherwise users will be redirected to the normal login page. By default set to false.
* `customauth_only_allow_source` - If you are using an external tool to authenticate with MISP and would like to only allow the tool's url as a valid point of
entry then set this field. Empty by default.
* `customauth_name` - The name of the authentication method, this is cosmetic only and will be shown on the user creation page and logs.
By default set to 'External authentication'
* `customauth_disable_logout` - Disable the logout button for users authenticate with the external auth mechanism.
By default set to true.
* `customauth_custom_password_reset` - Provide your custom authentication users with an external URL to the authentication system to reset their passwords. Empty by default.
* `customauth_custom_logout` - Provide a custom logout URL for your users that will log them out using the authentication system you use. Empty by default.
* `enrichment_services_enable` - Enable/disable the enrichment services. By default set to true.
* `enrichment_services_url` - The url used to access the enrichment services. By default set to 'http://127.0.0.1'.
* `enrichment_services_port` - The port used to access the enrichment services. By default set to 6666.
* `enrichment_timeout` - Set a timeout for the enrichment services. By default set to 10.
* `enrichment_hover_enable` - Enable/disable the hover over information retrieved from the enrichment modules.
By default set to true.
* `enrichment_hover_timeout` - Set a timeout for the hover services. By default set to  5.
* `export_services_enable` - Enable/disable the import services. By default set to true.
* `export_services_url` - The url used to access the export services. By default set to 'http://127.0.0.1'.
* `export_services_port` - The port used to access the export services. By default set to 6666.
* `export_timeout` - Set a timeout for the import services. By default set to 10.
* `import_services_enable` - Enable/disable the import services. By default set to true.
* `import_services_url` - The url used to access the import services. By default set to 'http://127.0.0.1'.
* `import_services_port` - The port used to access the import services. By default set to 6666.
* `import_timeout` - Set a timeout for the import services. By default set to 10.
* `cortex_services_enable` -    Enable/disable the import services. By default set to false.
* `cortex_services_url` -   The url used to access Cortex. By default, it is accessible at http://cortex-url/api.
* `cortex_services_port` - The port used to access Cortex. By default, this is port 9000.
* `cortex_authkey` - Set an authentication key to be passed to Cortex.
* `cortex_timeout` - Set a timeout for the import services. By default set to 120.
* `cortex_ssl_verify_peer` - Set to false to disable SSL verification. This is not recommended.
* `cortex_ssl_verify_host` - Set to false if you wish to ignore hostname match errors when validating certificates.
* `cortex_ssl_allow_self_signed` - Set to true to enable self-signed certificates to be accepted. This requires `cortex_ssl_verify_peer` to be enabled.
* `cortex_ssl_cafile` - Set to the absolute path of the Certificate Authority file that you wish to use for verifying SSL certificates.

#### ApacheShibbAuth
* `shib_default_org` - Default organisation for user creation when using Shibboleth authentication plugin. By default set to 1.
* `egroup_role_match` - Group to role mapping used for authorization when using Shibboleth authentication plugin.
Empty by default ({}).

### Services

* `webservername` = The name of the service of the web server on top of which MISP is running. By default httpd.
* `redis_server` = If the redis database will be installed locally or not, meaning that the redis server will be installed.
By default true.

### GnuPG

To set up GPG fist you need to generate a gpg key with:
```bash
gpg --gen-key
```
Note that the email should be the email set up in the GnuPG part of the configuration (gpg_email parameter), and the same applies for the password (gpg_password parameter). There are known cases of errors when using it with a password (instead of passwordless as in the default configuration). If it gives an error run is as root.

Then move the key to the directory set up as home directory (gpg_homedir parameter), set apache as owner and group and the selinux context httpd_sys_rw_content_t.
```bash
mv ~/.gnupg /var/www/MISP/
chown -R apache:apache /var/www/MISP/.gnupg
chcon -R -t httpd_sys_rw_content_t /var/www/MISP/.gnupg
```

Finally export the public key to the webroot
```bash
sudo -u apache gpg --homedir /var/www/MISP/.gnupg --export --armor YOUR-EMAIL > /var/www/MISP/app/webroot/gpg.asc
```
