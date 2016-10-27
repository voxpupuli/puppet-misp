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
    git_tag          => 'v2.4.51',
    stix_git_repo    => 'git://github.com/STIXProject/python-stix.git',
    stix_git_tag     => 'v1.1.1.4',
    cybox_git_repo   => 'git://github.com/CybOXProject/python-cybox.git',
    cybox_git_tag    => 'v2.1.0.12',
    org_id           => '1',
    email            => 'someone.someother@cern.ch',
    contact          => 'someone.someother@cern.ch',
    salt             => 'peNcwg1FLo8IAs<6vp19pGm+KraYr4lo',
    cipherseed       => '3065587201289743977828085477234109470468333142712980330186178699',
    import_service   => true,
    export_service   => true,
  }

```

### Parameters for MIPS Class.
* `git_tag` - Tag or version of MISP that will be installed. By default "v2.4.51"
* `install_dir` - Directory in which to install MISP. By default "/var/www/MISP/"
* `config_dir` - Directory in which the configuration of MISP should be located. By default "/var/www/MISP/app/Config/"
* `stix_git_repo`- Git url of the STIX module. By default "git://github.com/STIXProject/python-stix.git"
* `stix_git_tag`- Tag or version of the STIX module. By default "v1.1.1.4"
* `cybox_git_repo`- Git url of the CyBox repository. By default "git://github.com/CybOXProject/python-cybox.git"
* `cybox_git_tag`- Tag or version of the CyBox module. By default "v2.1.0.12"
* `email` - Email address of the MISP installation. By default "root@localhost"
* `contact` - Contact address of the MISP installation. By default "root@localhost"
* `org_id` - Id of the organisation that owns the MISP instance. By default is set to 1, meaning the first Organisation in the system
* `live` - If MISP should be live or not (be accessible to not admins). By default true
* `session_timeout` - Session timeout in minutes, default is 1 hour
* `site_admin_debug` - Full debug mode (not recommended). By default false
* `salt` - By default "Rooraenietu8Eeyo<Qu2eeNfterd-dd+"
* `cipherseed` - Empty by default
* `gpg_email` - By default "no-reply@localhost"
* `gpg_homedir` - By default "/var/www/html"
* `enrichment_service` - Enrichment service. By default false
* `enrichment_hover` - Enrichment hover. By default false
* `import_service` - Import services (both API and UI level). By default false
* `export_service` - Export services (both API and UI level). By default false
* `webservername` - Name of the web server process on top of which MISP runs. By default "httpd"
* `db_name` - Name of the database. By default "misp"
* `db_user` - Name of the user with rights on the database. By defeault "misp"
* `db_host` - Name of the host in which the database is located. By default "misp.com"
* `db_port` - Port to connect to the database in the specified host. By default 3306
* `timezone`- The timezone of the host in which MISP is installed. By default "UTC"
* `default_user` - The low level user to whom to assign the ownership of the files. By default "apache"
* `default_group` = The low level group to whom to assign the ownership of the files.  By default "apache"
* `default_high_user` = The high level user as whom to run shells and scripts. By default "root"
* `default_high_group` = The high level group as whom to run shells and scripts. By default "apache"

The *email* variable specifies the email address that will be used for as sender for the notifications, the *contact* email address is the
one that will be shown in the displayed messages.
