# == Class: galaxy::install
#
# Clones the remote repository
#
# === Parameters
#
# [*directory*]
#   The main directory for galaxy instances that will be installed on this
#   server.
#
# [*galaxy_branch*]
#   Which branch of galaxy's development to pull from. Options are "stable" and
#   "deafult", where default is the primary branch for development work.
#
# === Examples
#
#  galaxy::install{ 'development':
#    directory => '/home/galaxy/'
#  }
# # === Authors
#
# M. Loaec <mloaec@versailles.inra.fr>
# O. Inizan <oinizan@versailles.inra.fr>
# Eric Rasche <rasche.eric@yandex.ru>
#
# === Copyright
#
# Copyright 2014, unless otherwise noted.
#
class galaxy::install(
  $install_directory = "$galaxy::params::app_directory/",
  $galaxy_branch     = $galaxy::params::galaxy_branch,
  $galaxy_repository     = $galaxy::params::galaxy_repository,
){
  vcsrepo { $install_directory:
    require  => Class ['galaxy'],
    ensure   => present,
    user     => 'galaxy',
    source   => $galaxy_repository,
    revision => $galaxy_branch,
    provider => 'hg_galaxy',
  }
}
