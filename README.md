# MISP MODULE

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - Getting started with the misp module](#setup)
    * [What misp affects](#what-misp-affects)
4. [Usage - Configuration options and additional functionality](#usage)

This module installs and configures MISP (Malware Information Sharing Platform) on CentOS 7. 
It has been tested on Puppet 3.8.7 and with MISP versions 2.4.50 and 2.4.51.

## Module Description

This module installs and configures MISP on CentOS 7. It installs all the needed dependencies, configures MISP and 
starts the services. However it does not create the database or the gpg key, that is up to the user to do. In addition it does not 
set up the webserver on top of which MISP would run, menaning that apache, nginx or another web server of your choice will be needed (nevertheless
the module need to know to know the name of the deamon of the web server (e.g. httpd)).

As mentioned before database will need to be set up, the schema imported and then create a user with rights to access misp database. 
If gpg will be used, the gpg key will need to be created.

The module follows the installation instructions that can be found [here](https://github.com/MISP/MISP/tree/2.4/INSTALL). Also details about the 
database and gpg key creation and set up can be found there.

NOTE: the configuration and database files of MISP are used as templates on the module, therefore if the are major changes on the version of MISP the template might cause troubles
and need to be updated.

## Setup

### What misp affects

The MISP module will not alter any OS files, all the configuration will happen in /install/directory/app/Config/
where the *core.php*, *bootstrap.php*, *database.php* and *config.php* files will be deployed with the established values.

This module needs the following packages:

    * gcc: Needed for compiling Python modules
    * git: Needed for pulling the MISP code and other git repositories which MISP depends on
    * zip, redis, haveged and maria db
    * python-devel, python-pip, python-lxml, python-dateutil, python-six, python-lm, importlib [pip], Crypt_GPG [pear]: Python related packages
    * rh-php56, rh-php56-php-fpm, rh-php56-php-devel, rh-php56-php-mysqlnd, rh-php56-php-mbstring, php-pecl-redis, php-pear: PHP 5.6 related packages
    * php-mbstring: Python package required by Crypt_GPG
    * libxslt-devel', 'zlib-devel

The services needed by MISP are: 

    * rh-php56-php-fpm
    * haveged
    * redis
    * The 4 workers and the scheduler [CakeResque]

## Usage

### Basic usage

In orther to use the module it would be enough with including the module:
```puppet
include ::misp,
```

Or the class:
```puppet
class{ ::misp:}
```

An the module will use all parameters with default values, these values are specified later on.

### Another usage example

```puppet
class {'::misp':
    git_tag          => 'v2.4.52',
    email            => 'someone.someother@somewhere.ch',
    contact          => 'someone.someother@somewhere.ch',
    salt             => 'Rooraenietu8Eeyo<Qu2eeNfterd-dd+',
    cipherseed       => '9999999999999999999999999999999999999999999999999999999999999999',

  }

```

### Parameters for MIPS Class.

The MISP class can take every parameter needed to change the configuration of MISP. However, they all have the default value 
set to the recommended value by MISP so there is no need to change it. The parameters can be classified in the ones needed for 
the installation of MISP itself, for the database, for the configuration, and for the services. The parameters are the following:

#### MISP installation
  
* `misp_git_tag` - Tag or version of MISP that will be installed. By default "v2.4.51"
* `install_dir` - Directory in which to install MISP. By default "/var/www/MISP/"
* `config_dir` - Directory in which the configuration of MISP should be located. By default "{install_dir}/app/Config/"
* `stix_git_repo`- Git url of the STIX module. By default "git://github.com/STIXProject/python-stix.git"
* `stix_git_tag`- Tag or version of the STIX module. By default "v1.1.1.4"
* `cybox_git_repo`- Git url of the CyBox repository. By default "git://github.com/CybOXProject/python-cybox.git"
* `cybox_git_tag`- Tag or version of the CyBox module. By default "v2.1.0.12"
* `timezone`- Timezone where the instance has been placed. By default "UTC"
* `default_user`- User as which to run the installation of MISP. By default apache
* `default_group`- Group as which to run the installation of MISP. By default apache
* `default_high_user`- In some cases root permissions are need in the installation, this user will be used in 
those cases. By default root
* `default_high_group`- In some cases root permissions are need in the installation, this group will be used in 
                        those cases. By default apache

##### Database configuration

* `db_name` - Name of the database. By default "misp"
* `db_user` - Name of the user with rights on the database. By defeault "misp"
* `db_host` - Name of the host in which the database is located. By default "misp.com"
* `db_port` - Port to connect to the database in the specified host. By default 3306
* `db_password` - Password used to access the database. By default is empty

##### MISP configuration


##### config.php
  * `debug` = 0,
  * `site_admin_debug` - Full debug mode (not recommended). By default false
##### Security
  $security_level = 'medium',
  * `salt` - By default "Rooraenietu8Eeyo<Qu2eeNfterd-dd+"
  * `cipherseed` - Empty by default
  $auth_method = '', # Empty means default user-password login method
  $password_policy_length = 6,
  $password_policy_complexity = '/((?=.*\\d)|(?=.*\\W+))(?![\\n])(?=.*[A-Z])(?=.*[a-z]).*$/',
##### MISP
  $footermidleft = '',
  $footermidright = '',
  * `host_org_id` - Id of the organisation that owns the MISP instance. By default is set to 1, meaning the first Organisation in the system
  $email_subject_org = 'ORGNAME',
  $showorg = true,
  $background_jobs = true,
  $cached_attachments = true,
  * `email` - Email address of the MISP installation, this address is used as sender (from) when sending notifications. By default "root@localhost"
  * `contact` - Contact address of the MISP installation, this address is used in error messages. By default "root@localhost"
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
  * `live` - If MISP should be live or not (be accessible to not admins). By default true
  $extended_alert_subject = false,
  $default_event_threat_level = '1',
  $newUserText = 'Dear new MISP user,\\n\\nWe would hereby like to welcome you to the $org MISP community.\\n\\n Use the credentials below to log into MISP at $misp, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: $username\\nPassword: $password\\n\\nIf you have any questions, don\'t hesitate to contact us at: $contact.\\n\\nBest regards,\\nYour $org MISP support team',
  $passwordResetText = 'Dear MISP user,\\n\\nA password reset has been triggered for your account. Use the below provided temporary password to log into MISP at $misp, where you will be prompted to manually change your password to something of your own choice.\\n\\nUsername: $username\\nYour temporary password: $password\\n\\nIf you have any questions, don\'t hesitate to contact us at: $contact.\\n\\nBest regards,\\nYour $org MISP support team',
  $enableEventBlacklisting = false,
  $enableOrgBlacklisting = false,
  $log_client_ip = false,
  $log_auth = false,
  $disableUserSelfManagement = false,
  $block_old_event_alert = false,
  $block_old_event_alert_age = 30,
  $maintenance_message = 'Great things are happening! MISP is undergoing maintenance, but will return shortly. You can contact the administration at $email.',
  $email_subject_TLP_string = 'TLP Amber',
  $terms_download = false,
  $showorgalternate = false,
##### GPG
  $gpg_onlyencrypted = false,
  * `gpg_email` - By default "no-reply@localhost"
  * `gpg_homedir` - By default "/var/www/html"
  $gpg_password = '',
  $gpg_bodyonlyencrypted = false,
##### SMIME
  $smime_enabled = false,
  $smime_email = '',
  $smime_cert_public_sign = '',
  $smime_key_sign = '',
  $smime_password = '',
##### Proxy
  $proxy_host = '',
  $proxy_port = '',
  $proxy_method = '',
  $proxy_user = '',
  $proxy_password = '',
##### SecureAuth
  $secure_auth_amount = 5,
  $secure_auth_expire = 300,
##### Plugin
  $customAuth_disable_logout = true,
  $ZeroMQ_enable = false,
  $ZeroMQ_port = 50000,
  $ZeroMQ_redis_host = 'localhost',
  $ZeroMQ_redis_port = 6379,
  $ZeroMQ_redis_password = '',
  $ZeroMQ_redis_database = '1',
  $ZeroMQ_redis_namespace = 'mispq',
  $RPZ_policy = 0,
  $RPZ_walled_garden = '127.0.0.1',
  $RPZ_serial = '$date00',
  $RPZ_refresh = '2h',
  $RPZ_retry = '30m',
  $RPZ_expiry = '30d',
  $RPZ_minimum_ttl = '1h',
  $RPZ_ttl = '1w',
  $RPZ_ns = 'localhost',
  $RPZ_email = 'root.localhost',
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
##### ApacheShibbAuth
  $shib_default_org = '1',
  $egroup_role_match = {},

##### Services

* `webservername` = The name of the service of the web server on top of which MISP is running. By default httpd
* `redis_server` = If the redis database will be installed locally or not, meaning that the redis server will be installed. By default true


 
  
The *email* variable specifies the email address that will be used for as sender for the notifications, the *contact* email address is the 
one that will be shown in the displayed messages.
