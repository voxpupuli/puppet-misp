# misp

# Module providing capabilities to install the MISP platform

basically follows:
https://github.com/MISP/MISP/tree/2.4/INSTALL

NOTE: for now it is only tested and working for CentOS 7, there is work to be 
done in order to provide support for the rest of OS.

This module only installs configures the files needed for MISP to work. However 
it does not configure any webserver on top of which MISP would run, although it 
is needed to specify it.

## Example

```puppet
class {'::misp':
    git_tag          => 'v2.4.51',
    orgname          => 'CERN',
    email            => 'someone.someother@cern.ch',
    contact          => 'someone.someother@cern.ch',
    salt             => 'peNcwg1FLo8IAs<6vp19pGm+KraYr4lo',
    cipherseed       => '3065587201289743977828085477234109470468333142712980330186178699',
    import_service   => true,
    export_service   => true,
  }

```

## Parameters for MIPS Class.
* `db_name` - By default "misp"
* `db_user` - By defeault "misp"
* `db_host` - By default "misp.com"
* `db_port` - By default 5505
* `git_tag` - By default "v2.4.51"
* `salt` - By default "Rooraenietu8Eeyo<Qu2eeNfterd-dd+"
* `cipherseed` - Empty by default
* `orgname` - By default "ORGNAME"
* `webservername` - By default "httpd"
* `email` - By default "root@localhost"
* `contact` - By default "root@localhost"
* `live` - By default true
* `site_admin_debug` - By default false
* `enr_service` - By default false
* `enr_hover` - By default false
* `gnu_email` - By default "no-reply@localhost"
* `gnu_homedir` - By default "/var/www/html"
* `import_service` - By default false
* `export_service` - By default false
* `install_dir` - By default "/var/www/MISP/"
* `config_dir` - By default "/var/www/MISP/app/Config/"


//////TODO
#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with misp](#setup)
    * [What misp affects](#what-misp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with misp](#beginning-with-misp)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A one-maybe-two sentence summary of what the module does/what problem it solves.
This is your 30 second elevator pitch for your module. Consider including
OS/Puppet version it works with.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What misp affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with misp

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
