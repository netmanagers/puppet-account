# == Define: account::user
#
# A defined type for managing user accounts
# Features:
#   * Account creation w/ UID control
#   * Setting the login shell
#   * Group creation w/ GID control (optional)
#   * Home directory creation ( and optionally management via /etc/skel )
#   * Support for system users/groups
#   * SSH key management (optional)
#
# === Parameters
#
# [*ensure*]
#   The state at which to maintain the user account.
#   Can be one of "present" or "absent".
#   Defaults to present.
#
# [*username*]
#   The name of the user to be created.
#   Defaults to the title of the account::user resource.
#
# [*uid*]
#   The UID to set for the new account.
#   If set to undef, this will be auto-generated.
#   Defaults to undef.
#
# [*password*]
#   The password to set for the user.
#   If the account is newly created, the password is left as the system
#   creates it.
#   The default is to leave password untouched. 
#
# [*shell*]
#   The user's default login shell.
#   The default is '/bin/bash'
#
# [*manage_home*]
#   Whether the underlying user resource should manage the home directory.
#   This setting only determines whether or not puppet will copy /etc/skel.
#   Regardless of its value, at minimum, a home directory and a $HOME/.ssh
#   directory will be created. Defaults to true.
#
# [*home_dir*]
#   The location of the user's home directory.
#   Defaults to "/home/$title".
#
# [*create_group*]
#   Whether or not a dedicated group should be created for this user.
#   If set, a group with the same name as the user will be created.
#   Otherwise, the user's primary group will be set to "users".
#   This setting supersedes $account::users_gid
#   Defaults to true.
#
# [*groups*]
#   An array of additional groups to add the user to.
#   Defaults to an empty array.
#
# [*system*]
#   Whether the user is a "system" user or not.
#   Defaults to false.
#
# [*ssh_key*]
#   A string containing a public key suitable for SSH logins
#   If set to 'undef', no key will be created.
#   Defaults to undef.
#
# [*ssh_key_type*]
#   The type of SSH key to manage. Accepts any value accepted by
#   the ssh_authorized_key's 'type' parameter.
#   Defaults to 'ssh-rsa'.
#
# [*ssh_key_options*]
#   A string or array of options to be added to the SSH Key (like "command=",
#   etc.) If set to 'undef', no key will be created.
#   Defaults: empty.
#
# [*comment*]
#   Sets comment metadata for the user
#
# [*gid*]
#   Sets the primary group of this user, if $create_group = false
#   Defaults to 'users'
#     WARNING: Has no effect if used with $create_group = true
#
# === Examples
#
#  account { 'sysadmin':
#    home_dir => '/opt/home/sysadmin',
#    groups   => [ 'sudo', 'wheel' ],
#  }
#
# === Authors
#
# Tray Torrance <devwork@warrentorrance.com>
# Javier Bertoli <javier@netmanagers.com.ar>
#
define account::user(
  $username        = $title,
  $password        = '',
  $shell           = '/bin/bash',
  $manage_home     = true,
  $home_dir        = '',
  $home_dir_perms  = '',
  $create_group    = true,
  $system          = false,
  $uid             = '',
  $ssh_key         = '',
  $ssh_key_type    = 'ssh-rsa',
  $ssh_key_options = '',
  $groups          = '',
  $ensure          = 'present',
  $comment         = "${title} Puppet-managed User",
  $gid             = ''
) {

  include account

  $real_home_dir = $home_dir ? {
    ''      => "${account::home_dir}/${username}",
    default => $home_dir,
  }

  $real_home_dir_perms = $home_dir_perms ? {
    ''      => $account::home_dir_perms,
    default => $home_dir_perms,
  }

  $real_uid = $uid ? {
    ''      => undef,
    default => $uid,
  }

  $real_password = $password ? {
    ''      => undef,
    default => $password,
  }
  # We ensure the user has a group
  $real_gid = $gid ? {
    ''      => $account::users_gid,
    default => $gid,
  }
  
  $real_primary_group = $create_group ? {
    true    => $username,
    default => $real_gid,
  }

  $array_groups = is_array($groups) ? {
    false => $groups ? {
      ''      => $account::array_users_groups,
      default => [$groups],
      },
    default => $groups,
  }

  case $ensure {
    present: {
      $home_ensure = 'directory'
      $home_owner  = $username
      $home_group  = $real_primary_group
      if $create_group {
        Group[$username] -> User[$username]
      }
      User[$username] -> File["${username}_home"] -> File["${username}_sshdir"]
    }
    absent: {
      $home_ensure = 'absent'
      $home_owner  = undef
      $home_group  = undef
      File["${username}_sshdir"] -> File["${username}_home"] -> User[$username]
      if $create_group {
        User[$username] -> Group[$username]
      }
    }
    default: {
      err( "Invalid value given for ensure: ${ensure}. Must be one of present,absent." )
    }
  }

  if $create_group == true {
    group { $username:
      ensure => $ensure,
      name   => $real_primary_group,
      system => $system,
      gid    => $real_uid,
    }
  }

  user { $username:
    ensure     => $ensure,
    name       => $username,
    comment    => $comment,
    uid        => $real_uid,
    password   => $real_password,
    shell      => $shell,
    gid        => $real_primary_group,
    groups     => $array_groups,
    home       => $real_home_dir,
    managehome => $manage_home,
    system     => $system,
  }

  file { "${username}_home":
    ensure  => $home_ensure,
    path    => $real_home_dir,
    owner   => $home_owner,
    group   => $home_group,
    mode    => $real_home_dir_perms,
  }

  file { "${username}_sshdir":
    ensure  => $home_ensure,
    path    => "${real_home_dir}/.ssh",
    owner   => $home_owner,
    group   => $home_group,
    mode    => '0700',
  }

  if $ssh_key != '' {
    File["${username}_sshdir"]->
    account::sshkey { $username:
      ensure       => $ensure,
      ssh_key_type => $ssh_key_type,
      ssh_key      => $ssh_key,
      options      => $ssh_key_options,
    }
  }
}

