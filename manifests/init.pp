# Class: postgresql
#
# This module manages PostgreSQL.
#
# Parameters:
#
# There are no default parameters for this class. All module parameters are managed
# via the postgresql::params class
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
#   include postgresql
# }
class postgresql inherits postgresql::params {
  class { 'postgresql::package':
    notify => Class['postgresql::service'],
  }

  class { 'postgresql::config': 
    require => Class['postgresql::package'],
    notify  => Class['postgresql::service']
  }

  class { 'postgresql::service': }
}