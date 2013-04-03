# Class: postgresql::service
#
# This module manages PostgreSQL service management
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
class postgresql::service {
  service { 'postgresql':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}