# Define to handle a user's sshkey

define account::sshkey (
  $username       = $title,
  $ssh_key        = '',
  $ssh_key_type   = 'ssh-rsa',
  $ensure         = present
) {

  include account

  if $ssh_key != '' {
    ssh_authorized_key { $title:
      ensure  => $ensure,
      type    => $ssh_key_type,
      name    => "${username} SSH Key",
      user    => $username,
      key     => $ssh_key,
    }
  } else {
    err( "Invalid value given for ssh-key. Can't be empty." )
  }
}
