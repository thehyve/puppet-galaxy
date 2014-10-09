#
#
#
#
#
class galaxy::manage_tools {
  $directory = $galaxy::params::app_directory
  $cmd = "python $directory/scripts/manage_tools.py"
  exec { 'Manage Tools Upgrade':
    path     => '/usr/bin:/usr/sbin:/bin:/sbin',
    cwd      => $directory,
    command  => "$cmd upgrade",
    user     => 'galaxy',
    group    => 'galaxy',
    unless   => "test \"\$($cmd db_version)\" -eq \"\$($cmd version)\"",
    provider => shell,
    require  => Class['galaxy::create_db'],
  }
}
