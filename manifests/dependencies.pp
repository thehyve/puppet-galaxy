# == Class: galaxy::dependencies
#
# Dependencies for the galaxy server
#
#
# === Authors
#
# M. Loaec <mloaec@versailles.inra.fr>
# O. Inizan <oinizan@versailles.inra.fr>
# Eric Rasche <rasche.eric@yandex.ru>
#
# === Copyright
#
# Copyright 2014, unless otherwise noted.
#
class galaxy::dependencies(){

  $packages = ['mercurial', 'python', 'tar', 'libapache2-mod-uwsgi', 'python-pip', 'python-virtualenv']

  package { $packages:
    ensure => installed,
  }

  if 'Debian' == $osfamily {
    package { 'dpkg' :
      ensure => installed,
    }
  }

}
