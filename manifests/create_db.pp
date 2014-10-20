#
#
#
#
#
#
class galaxy::create_db {
  include ::galaxy::universe

  $directory = $galaxy::params::app_directory

  # run create_db.sh only if the conection string changes
  file { "$directory/.db_connection":
    owner   => 'galaxy',
    group   => 'galaxy',
    mode    => '0600',
    content => "$::galaxy::universe::db_connection\n",
  } ~>
  exec { 'create_db.sh':
    require     => Class['galaxy::universe'],
    path        => '/usr/bin:/usr/sbin:/bin:/sbin',
    cwd         => $directory,
    user        => 'galaxy',
    group       => 'galaxy',
    command     => "$directory/create_db.sh",
    timeout     => 500,
    refreshonly => true,
  }
}
