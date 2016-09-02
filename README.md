# MISP MODULE

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with misp](#setup)
    * [What misp affects](#what-misp-affects)
4. [Usage - Configuration options and additional functionality](#usage)

This module install and configure MISP (Malware Information Sharing Platform) on CentOS 7. 
It has been tested on Puppet 3.8.7 and with MISP versions 2.4.50 and 2.4.51.

## Module Description

This module installs and configure MISP on CentOS 7. It installs all the dependencies needed, configures MISP and 
starts the services. However it does not create the database, that is up to the user to do. In addition it does not 
set up the webserver on top of which MISP would run, menaning that apache, nginx or another one will be needed (nevertheless
it is needed for the module to know the name of the process of the web server).

The module follows the instructions that can be found [here](https://github.com/MISP/MISP/tree/2.4/INSTALL)

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

The services needed by MISP are 

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
* `email` - Email address of the MISP installation. By default "root@localhost"
* `contact` - Contact address of the MISP installation. By default "root@localhost"
* `org_id` - Id of the organisation that owns the MISP instance. By default is set to 1, meaning the first Organisation in the system
* `live` - If MISP should be live or not (be accessible to not admins). By default true
* `site_admin_debug` - If the site admins page is on debug mode (not recommended). By default false
* `salt` - By default "Rooraenietu8Eeyo<Qu2eeNfterd-dd+"
* `cipherseed` - Empty by default
* `gnu_email` - By default "no-reply@localhost"
* `gnu_homedir` - By default "/var/www/html"
* `enr_service` - Enrichment service. By default false
* `enr_hover` - Enrichment hover. By default false
* `import_service` - Import services (both API and UI level). By default false
* `export_service` - Export services (both API and UI level). By default false
* `webservername` - Name of the web server process on top of which MISP runs. By default "httpd"
* `db_name` - Name of the database. By default "misp"
* `db_user` - Name of the user with rights on the database. By defeault "misp"
* `db_host` - Name of the host in which the database is located. By default "misp.com"
* `db_port` - Port to connect to the database in the specified host. By default 5505
