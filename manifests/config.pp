# Class: postgresql::config
#
# This module manages PostgreSQL bootstrap and configuration
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
class postgresql::config (
  $encoding = $postgresql::params::encoding
) inherits postgresql::params {
  exec { 'postgresql_initdb':
    command   => "${postgresql::params::initdb} --encoding ${postgresql::params::encoding} --pgdata ${postgresql::params::data_dir}",
    creates   => "${postgresql::params::data_dir}/PG_VERSION",
    user      => $postgresql::params::user
  }
}