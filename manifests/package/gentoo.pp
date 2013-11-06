# Class: nginx::package::gentoo
#
# This module manages NGINX package installation for Gentoo based systems
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#  This module contains all of the required package for Gentoo.
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package::gentoo {
  $gentoo_packages = [
    'nginx'
  ]

  package { $gentoo_packages:
    ensure => present,
  }
}
