# Class: postgresql::package
#
# This module manages PostgreSQL package installation
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class postgresql::package {
  package { 'postgresql':
    ensure => latest,
  }
}