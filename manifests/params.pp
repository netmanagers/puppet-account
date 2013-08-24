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

  # Hash holding users information
  $users = 'users'

  $home_dir = '/home'
#  $config_dir = '/etc/skel'
#  $config_file = ''
#  $config_dir_mode = '0755'
#  $config_file_mode = '0644'
#  $config_file_owner = 'root'
#  $config_file_group = 'root'

  # local, ldap
  $backend = 'local'

  # General Settings
  $my_class = ''
#  $source = ''
#  $source_dir = ''
#  $source_dir_purge = false
#  $template = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false
}
