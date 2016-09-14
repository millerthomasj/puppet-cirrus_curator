# == Class: cirrus_curator
#
# Installs Elastic's Curator, manages the curator.conf file, creates an
# action.yml file for the actions to be performed by a given Curator job, and
# adds Curator jobs to cron for scheduled management of Elasticsearch indices.
#
# === Parameters
#
# [*ensure*]
#  String. Specify whether Curator should be installed and, if so, which version.
#
# [*provider*]
#  String. Puppet provider to use to install Curator.
#
# [*package_name*]
#  String. Name of package to be installed. Varies by provider.
#
# [*bin_path*]
#  String. Full path of the Curator binary file. Varies by provider (apt vs pip).
#
# [*config_dir*]
#  String. Path of Curator's configuration directory.
#
# [*config_filename*]
#  String. Name of Curator's YAML configuration file. Used by Curator command line
#  option '--config' (actually uses a concatenation of config_dir and
#  config_filename).
#
# [*config_group*]
#  String. Group to use for ownership of directories and files related to Curator.
#
# [*config_user*]
#  String. User to use for ownership of directores and files related to Curator.
#  Also determines which user's crontab to use for Curator cronjobs.
#
# [*curator_action_files*]
#  Hash. Primary key of hash must be 'curator_action_files', though all hashes with
#  this key in the entire Hiera(rchy) will be merged at runtime. Secondary key(s)
#  are used as the name(s) given to create_resources and should be the name(s) of
#  action_file(s)/cronjob(s) to be run by Curator. Tertiary keys are defined in
#  curator/action_file.pp and are used to provide configuration for cronjobs as well
#  as source OR content for action_files.
#
class cirrus_curator (
  $ensure               = $::cirrus_curator::params::curator_ensure,
  $provider             = $::cirrus_curator::params::curator_provider,
  $package_name         = $::cirrus_curator::params::curator_package_name,
  $bin_path             = $::cirrus_curator::params::curator_bin_path,
  $config_dir           = $::cirrus_curator::params::curator_config_dir,
  $config_filename      = $::cirrus_curator::params::curator_config_filename,
  $config_group         = $::cirrus_curator::params::curator_config_group,
  $config_user          = $::cirrus_curator::params::curator_config_user,
  $curator_action_files = hiera_hash(curator_action_files, {}),
) inherits cirrus_curator::params
{
  if ( $ensure != 'latest' ) or ( $ensure != 'absent' ) {
    if versioncmp($ensure, '4.0.0') < 0 {
      fail('This manifest only supports version 4.0.0 or later of curator')
    }
  }

  package { $package_name:
    ensure   => $ensure,
    provider => $provider,
    before   => Class['::cirrus_curator::config']
  }

  class { '::cirrus_curator::config':
    config_dir   => $config_dir,
    config_user  => $config_user,
    config_group => $config_group,
  }

#  validate_hash($curator_action_files)
#  create_resources('cirrus_curator::action_file', $curator_action_files)
}
