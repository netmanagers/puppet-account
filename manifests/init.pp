# = Class: account
#
# This is the main account class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, account class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $account_myclass
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $account_options
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $account_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $account_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in account::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
class account (
  $backend             = params_lookup( 'backend' ),
  $users_gid           = params_lookup( 'users_gid' ),
  $users_groups        = params_lookup( 'users_groups' ),
  $home_dir            = params_lookup( 'home_dir' ),
  $home_dir_perms      = params_lookup( 'home_dir_perms' ),
  $my_class            = params_lookup( 'my_class' ),
  $options             = params_lookup( 'options' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $version             = params_lookup( 'version' )
  ) inherits account::params {

  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $array_users_groups = is_array($users_groups) ? {
    false     => $users_groups ? {
      ''      => [],
      default => [$users_groups],
    },
    default   => $users_groups,
  }

  $manage_package = $account::bool_absent ? {
    true  => 'absent',
    false => $account::version,
  }

  $manage_file = $account::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $account::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $account::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $account::source ? {
    ''        => undef,
    default   => $account::source,
  }

  $manage_file_content = $account::template ? {
    ''        => undef,
    default   => template($account::template),
  }

  # The home directory must exist
  file { 'home.dir':
    ensure  => directory,
    path    => $account::home_dir,
    replace => $account::manage_file_replace,
    audit   => $account::manage_audit,
    noop    => $account::bool_noops,
  }

  # We include the backend to manage users
  include $account::backend

  if $account::my_class {
    include $account::my_class
  }
}
