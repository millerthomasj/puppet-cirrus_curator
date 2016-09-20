# == Class: cirrus_curator
#
# Installs python-elasticsearch-curator and provides a definition to schedule actions
#
# === Parameters
#
# [*ensure*]
#   Version of curator to be installed
#
# [*provider*]
#   Which provider to use for package installation.
#
# [*package_name*]
#   Name of the package to be installed.
#
# [*manage_repo*]
#   Enable repo management by enabling the official repositories.
#
# [*repo_version*]
#   Elastic repositories  are versioned per major release (2, 3)
#    select here which version you want.
#
# [*bin_file*]
#   Where the curator bin file lives.
#
# [*config_path*]
#   Where the curator configuration file is stored.
#
# [*actions_dir*]
#   Where the actions files are stored for curator.
#
# [*client_config*]
#   A hash that can be used to create a customized curator config file.
#
# [*logging_config*]
#   A hash that can be used to create a customized curator config file.
#
# [*actions*]
#  Manage your jobs in hiera (or manifest).
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
  $actions              = $::cirrus_curator::params::actions,
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

  validate_hash($actions)
  create_resources('cirrus_curator::action', $actions)
}
