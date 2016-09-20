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
  $provider             = $::cirrus_curator::params::provider,
  $package_name         = $::cirrus_curator::params::package_name,
  $manage_repo          = $::cirrus_curator::params::manage_repo,
  $repo_version         = $::cirrus_curator::params::repo_version,
  $bin_file             = $::cirrus_curator::params::bin_file,
  $config_path          = $::cirrus_curator::params::config_path,
  $actions_dir          = $::cirrus_curator::params::actions_dir,
  $client_config        = $::cirrus_curator::params::client_config,
  $logging_config       = $::cirrus_curator::params::logging_config,
) inherits cirrus_curator::params {

  if ( $ensure != 'latest' or $ensure != 'absent' ) {
    if versioncmp($ensure, '4.0.0') < 0 {
      fail('This version of the module only supports version 3.0.0 or later of curator')
    }
  }

  validate_bool($manage_repo)

  if ($manage_repo) {
    validate_string($repo_version)
  }

  class { '::cirrus_curator::install': }->
  class { '::cirrus_curator::config': }
}
