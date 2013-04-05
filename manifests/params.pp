# Class: postgresql::params
# 
# This class manages PostgreSQL parameters.
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
class postgresql::params {
  $user     = 'postgres'
  $port     = 5432
  $encoding = 'UTF8'
  $version  = '9.1'

  $bin_dir  = '/usr/lib/postgresql/${version}/bin'
  $data_dir = '/var/lib/postgresql/${version}/main'
  $initdb   = "${bin_dir}/initdb"
}