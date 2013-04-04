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

  $bin_dir  = '/usr/lib/postgresql/9.1/bin'
  $data_dir = '/var/lib/postgresql/9.1/main'
  $initdb   = "${bin_dir}/initdb"
}