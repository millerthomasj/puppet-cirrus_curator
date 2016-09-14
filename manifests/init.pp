# == Class: cirrus_curator
#
# Installs elasticsearch-curator and provides a definition to schedule jobs
#
#
# === Parameters
#
# [*ensure*]
#   String.  Version of curator to be installed
#   Default: latest
#
# [*jobs*]
#
#   Hash. Manage your jobs in hiera (or manifest).
#   Default: {}
#
# [*manage_repo*]
#   Boolean. Enable repo management by enabling the official repositories.
#   Default: false
#
# [*provider*]
#   String.  Name of the provider to install the package with.
#            If not specified will use system's default provider.
#   Default: undef
#
# [*repo_version*]
#   String.  Elastic repositories  are versioned per major release (2, 3)
#            select here which version you want.
#   Default: false
#
# === Examples
#
# * Installation:
#     class { 'curator': }
#
# * Installation with pip:
#     class { 'curator':
#       provider   => 'pip',
#       manage_pip => true,
#     }
#
class cirrus_curator (
  $ensure               = $::cirrus_curator::params::ensure,
  $package_name         = $::cirrus_curator::params::package_name,
  $provider             = $::cirrus_curator::params::provider,
  $bin_file             = $::cirrus_curator::params::bin_file,
  $host                 = $::cirrus_curator::params::host,
  $port                 = $::cirrus_curator::params::port,
  $use_ssl              = $::cirrus_curator::params::use_ssl,
  $ssl_validate         = $::cirrus_curator::params::ssl_validate,
  $ssl_certificate_path = $::cirrus_curator::params::ssl_certificate_path,
  $http_auth            = $::cirrus_curator::params::http_auth,
  $user                 = $::cirrus_curator::params::user,
  $password             = $::cirrus_curator::params::password,
  $jobs                 = $::cirrus_curator::params::jobs,
  $logfile              = $::cirrus_curator::params::logfile,
  $log_level            = $::cirrus_curator::params::log_level,
  $logformat            = $::cirrus_curator::params::logformat,
  $manage_repo          = $::cirrus_curator::params::manage_repo,
  $repo_version         = $::cirrus_curator::params::repo_version,
) inherits cirrus_curator::params {

  if ( $ensure != 'latest' or $ensure != 'absent' ) {
    if versioncmp($ensure, '4.0.0') < 0 {
      fail('This version of the module only supports version 3.0.0 or later of curator')
    }
  }

  case $manage_repo {
    true: {
      case $::osfamily {
        'Debian': {
          $_package_name = 'python-elasticsearch-curator'
          $_provider     = 'apt'
        }
        'RedHat': {
          $_package_name = 'python-elasticsearch-curator'
          $_provider     = 'yum'
        }
        default: {
          $_package_name = 'elasticsearch-curator'
          $_provider     = 'pip'
        }
      }
    }
    default: {
      $_package_name = $package_name
      $_provider     = $provider
    }
  }

#  validate_hash($jobs)
  validate_bool($manage_repo)
#
#  create_resources('curator::job', $jobs)

  if ($manage_repo == true) {
    validate_string($repo_version)

    # Set up repositories
    class { '::curator::repo': } ->
    package { $_package_name:
      ensure   => $ensure,
      provider => $_provider,
    }
  } else {
    package { $_package_name:
      ensure   => $ensure,
      provider => $_provider,
    }
  }
}
