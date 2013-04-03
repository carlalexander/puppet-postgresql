# Define: postgresql::resource::database
#
# This definition creates PostgreSQL database
#
# Parameters:
#   [*dbname*]     - Database name. Default [$name]
#   [*dbencoding*] - Database encoding. Default: UTF-8
#   [*dbowner*]    - Database owner. Default: postgres
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   postgresql::resource::database { 'test': }
define postgresql::resource::database (
  $dbname     = $name,
  $dbencoding = 'UTF-8',
  $dbowner    = $postgresql::params::user
) {
  Exec {
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    require => Class['postgresql'],
    user    => $postgresql::params::user
  }

  exec { "postgresql-create-database-${dbname}":
    command => "createdb -E ${dbencoding} -O ${dbowner} ${dbname}",
    unless  => "psql -aA -l | grep ' ${dbname} '"
  }
}