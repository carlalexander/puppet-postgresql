# Class: postgresql
#
# This module manages PostgreSQL.
#
# Parameters:
#
#   [*enable_backups*] - Flag to install backups. Default: true
#   [*backup_type*]    - Backup type. Rotating or normal
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# The module works with sensible defaults:
#
# node default {
#   include postgresql
# }
class postgresql (
  $enable_backups = true,
  $backup_type    = undef
) inherits postgresql::params {
  class { 'postgresql::package':
    notify => Class['postgresql::service'],
  }

  class { 'postgresql::config':
    enable_backups => $enable_backups,
    backup_type    => $backup_type,
    require        => Class['postgresql::package']
  }

  class { 'postgresql::service': }
}