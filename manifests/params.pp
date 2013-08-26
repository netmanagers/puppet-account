# Class: account::params
#
# This class defines default parameters used by the main module class account
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to account class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class account::params {

  # local, ldap
  $backend = 'local'

  # Default GID to use for users (defaults to 100, "users")
  # if $primary_group is false
  $users_gid = '100'
  $users_groups = ''

  $home_dir = '/home'
  $home_dir_perms = '0700'

## LDAP backend
#  $ldap_config_dir = '/etc/skel'
#  $ldap_config_file = ''
#  $ldap_config_dir_mode = '0755'
#  $ldap_config_file_mode = '0644'
#  $ldap_config_file_owner = 'root'
#  $ldap_config_file_group = 'root'
#  $ldap_source = ''
#  $ldap_source_dir = ''
#  $ldap_source_dir_purge = false
#  $ldap_template = ''

  # General Settings
  $my_class = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false
}
