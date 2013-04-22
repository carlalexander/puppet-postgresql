# Class: postgresql::config
#
# This module manages PostgreSQL configuration
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
  $enable_backups = true,
  $backup_type    = undef
) inherits postgresql::params {
  File {
    owner => $postgresql::params::user,
    group => $postgresql::params::user,
    mode  => '0755',
  }

  if ($enable_backups) {
    file { $postgresql::params::backup_dir:
      ensure  => directory,
    }

    file { '/usr/local/bin/pgsql_backup.config':
      ensure  => file,
      content => template('postgresql/pgsql_backup.config.erb'),
    }

    file { '/usr/local/bin/pgsql_backup.sh':
      ensure => file,
    }

    if ($backup_type == 'rotating') {
      File['/usr/local/bin/pgsql_backup.sh'] {
        source => 'puppet:///modules/postgresql/pg_backup_rotated.sh'
      }
    } else {
      File['/usr/local/bin/pgsql_backup.sh'] {
        source => 'puppet:///modules/postgresql/pg_backup.sh'
      }
    }

    cron { 'pgsql-backup':
      command => '/usr/local/bin/pgsql_backup.sh',
      user    => $postgresql::params::user,
      hour    => 2,
      minute  => 0,
      require => [File['/usr/local/bin/pgsql_backup.config'], File['/usr/local/bin/pgsql_backup.sh']],
    }
  }
}