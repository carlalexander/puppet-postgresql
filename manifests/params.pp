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
  $user = 'postgres'
  $port = 5432
}