# Define to handle a user's sshkey

define account::sshkey (
  $username       = $title,
  $ssh_key        = '',
  $ssh_key_type   = 'ssh-rsa',
  $options        = '',
  $comment        = '',
  $ensure         = present
) {

  include account

  $array_options = is_array($options) ? {
    false => $options ? {
      ''      => undef,
      default => [$options],
    },
    default => $options,
  }

  $ssh_key_comment = $comment ? {
    ''      => "${title} SSH Key",
    default => $comment,
  }

  if $ssh_key != '' {
    ssh_authorized_key { $title:
      ensure  => $ensure,
      name    => $ssh_key_comment,
      type    => $ssh_key_type,
      user    => $username,
      key     => $ssh_key,
      options => $array_options,
    }
  } else {
    err( "Invalid value given for ssh-key. Can't be empty." )
  }
}
