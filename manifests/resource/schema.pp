# Define: postgresql::resource::schema
#
# This definition creates PostgreSQL schema
#
# Parameters:
#   [*schema_name*] - Schema name. Default: [$name]
#   [*dbname*]      - Database name.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   postgresql::resource::schema { 'test': 
#     dbname => 'test'
#   }
define postgresql::resource::schema (
  $schema_name = $name,
  $dbname      = undef
) {
  Exec {
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    require => Class['postgresql'],
    user    => $postgresql::params::user
  }

  if ($dbname == undef) {
    fail('You must specify a database name')
  }

  exec { "postgresql-create-schema-${dbname}-${schema_name}":
    command => "psql -At --dbname=${dbname} --command=\"CREATE SCHEMA ${schema_name}\"",
    unless  => "psql -aA --dbname=${dbname} --command=\"\\dn\" | grep ${schema_name}"
  }
}