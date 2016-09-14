# == Class: cirrus_curator::config
#
# This class exists to coordinate the functions of Curator for
# Elasticsearch, including the configuration and action files referenced
# by Curator's command line interface.
#
# Elasticsearch Curator performs operations on Elasticsearch indices,
# such as managing index aliases, snapshots, optimizations, and deletions.
#
# === Parameters
#
# [*config_source*]
#  String. Path on Puppet server to source YAML file for Curator config.
#  If no config_source is supplied, this manifest defaults to using an ERB
#  template to generate Curator's configuration file.
#
# [*actions_dir*]
#  String. Path of Curator's actions.d directory, which stores all of Curator's
#  action files.
#

class cirrus_curator::config (
  $config_source    = undef,
  $config_dir       = $::cirrus_curator::params::config_dir,
  $config_dir_purge = $::cirrus_curator::params::config_dir_purge,
  $config_filename  = $::cirrus_curator::params::config_filename,
  $config_path      = $::cirrus_curator::params::config_path,
  $actions_dir      = $::cirrus_curator::params::actions_dir,
  $config_user      = $::cirrus_curator::params::config_user,
  $config_group     = $::cirrus_curator::params::config_group,
  $config_template  = $::cirrus_curator::params::config_template,
  $hosts            = ['localhost'],
  $port             = 9200,
  $url_prefix       = undef,
  $use_ssl          = false,
  $certificate      = undef,
  $client_cert      = undef,
  $client_key       = undef,
  $ssl_no_validate  = false,
  $http_auth        = false,
  $http_user        = undef,
  $http_password    = undef,
  $timeout          = 30,
  $master_only      = $::cirrus_curator::params::master_only,
  $log_level        = $::cirrus_curator::params::loglevel,
  $log_file         = $::cirrus_curator::params::logfile,
  $log_format       = $::cirrus_curator::params::logformat,
)
{
  File {
    owner => $config_user,
    group => $config_group,
  }

  if ( $config_source != undef ) {
    $config_content = file($config_source)
  }
  else {
    $config_content = template($config_template)
  }

  file { $config_dir:
    ensure       => directory,
    purge        => $config_dir_purge,
    recurse      => $config_dir_purge,
    recurselimit => 1,
  }

  file { $config_path:
    ensure  => file,
    content => $config_content,
    require => File[$config_dir],
  }

  file { $actions_dir:
    ensure  => directory,
    purge   => $config_dir_purge,
    recurse => $config_dir_purge,
    require => File[$config_dir],
  }
}
