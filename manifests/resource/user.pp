# Define: postgresql::resource::user
#
# This definition creates a PostgreSQL database user
#
# Parameters:
#   [*username*]         - Username of the new user. Default: [$name]
#   [*password*]         - User password
#   [*createdb*]         - User is allowed to create databases. Default: false
#   [*createrole*]       - User is allowed to create roles. Default: false
#   [*superuser*]        - User is a super user. Default: false
#   [*connection_limit*] - Connection limit. Default: -1
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   postgresql::resource::user { 'localuser':
#     password => 'password'
#   }
define postgresql::resource::user (
  $username         = $name,
  $password         = undef,
  $createdb         = false,
  $createrole       = false,
  $superuser        = false,
  $connection_limit = -1
) {
  Exec {
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    require => Class['postgresql'],
    user    => $postgresql::params::user
  }

  if ($password == undef) {
    fail('You must specify a password')
  }

  $createrole_sql = $createrole ? { true => 'CREATEROLE', default => 'NOCREATEROLE' }
  $createdb_sql   = $createdb   ? { true => 'CREATEDB'  , default => 'NOCREATEDB' }
  $superuser_sql  = $superuser  ? { true => 'SUPERUSER' , default => 'NOSUPERUSER' }

  exec { "postgresql-create-user-${username}":
    command => "psql -At --command=\"CREATE ROLE \"${username}\" ENCRYPTED PASSWORD '${password}' LOGIN ${createrole_sql} ${createdb_sql} ${superuser_sql} CONNECTION LIMIT ${connection_limit}\"",
    unless  => "psql -At --command=\"SELECT rolname FROM pg_roles WHERE rolname='${username}'\" | grep ${username}"
  }  
}