class postgresql inherits postgresql::params {
  class { 'postgresql::package':
    notify => Class['postgresql::service'],
  }

  class { 'postgresql::service': }
}