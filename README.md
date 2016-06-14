# Puppet module: account

## [Maintainer wanted](https://github.com/netmanagers/puppet-account/issues/new)

**WARNING WARNING WARNING**

[puppet-account](https://github.com/netmanagers/puppet-account) is not currently being maintained, 
and may have unresolved issues or not be up-to-date. 

I'm still using it on a daily basis (with Puppet 3.8.5) and fixing issues I find
while using it. But sadly, I don't have the time required to actively add new features,
fix issues other people report or port it to Puppet 4.x.

If you would like to maintain this module,
please create an issue at: https://github.com/netmanagers/puppet-account/issues
offering yourself.

## Getting started

This is yet another puppet module to manage user accounts, sudo entries and SSH keys

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-account

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install account with default settings

        class { 'account': }

  This just enables the class, checks for the users' homedir to exist and loads the 
  desired backend (currently only local accounts).

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
This module provides some defines to manage users, their SSH keys and 


## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-account.png?branch=master)](https://travis-ci.org/netmanagers/puppet-account)
