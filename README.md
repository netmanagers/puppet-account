# Puppet module: account

This is yet another puppet module to manage user accounts, sudo entries and SSH keys

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-account

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install account with default settings

        class { 'account': }

* Install a specific version of account package

        class { 'account':
          version => '1.0.1',
        }

* Remove account resources

        class { 'account':
          absent => true
        }

* Enable auditing without without making changes on existing account configuration *files*

        class { 'account':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'account':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file

        class { 'account':
          source => [ "puppet:///modules/netmanagers/account/account.conf-${hostname}" , "puppet:///modules/example42/account/account.conf" ], 
        }


* Use custom source directory for the whole configuration dir
        class { 'account':
          source_dir       => 'puppet:///modules/netmanagers/account/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'account':
          template => 'netmanagers/account/account.conf.erb',
        }

* Automatically include a custom subclass

        class { 'account':
          my_class => 'example42::my_account',
        }



## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-account.png?branch=master)](https://travis-ci.org/netmanagers/puppet-account)
