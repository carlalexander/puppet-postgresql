class postgresql {
  class { 'postgresql::package':
    notify => Class['postgresql::service'],
  }

  class { 'postgresql::service': }
}