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
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, account main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $account_source
#
# [*source_dir*]
#   If defined, the whole account configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $account_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true)
#   Can be defined also by the (top scope) variable $account_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, account main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $account_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $account_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
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
# [*package*]
#   The name of account package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include account"
# - Call account as a parametrized class
#
# See README for details.
#
#
class account (
  $users               = params_lookup( 'users' ),
  $backend             = params_lookup( 'backend' ),
  $home_dir            = params_lookup( 'home_dir' ),
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

  # We include the backend to manage users
  include $account::backend

  if $account::my_class {
    include $account::my_class
  }
}
