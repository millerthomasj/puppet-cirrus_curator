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
# [*config_dir*]
#  The directory to store the curator config file.
#
# [*config_dir_purge*]
#  Purge the configdir prior to installing file.
#
# [*config_path*]
#  Concatenation of config_dir and primary configuration filename.
#
# [*actions_dir*]
#  Path of Curator's actions.d directory, which stores all of Curator's
#  action files.
#
# [*config_user*]
#  Who owns the configuration file.
#
# [*config_group*]
#  Which group owns the configuration file.
#
# [*config_template*]
#  Template file to use in order to build the curator.yml file.
#

class cirrus_curator::config (
  $config_dir       = $::cirrus_curator::params::config_dir,
  $config_dir_purge = $::cirrus_curator::params::config_dir_purge,
  $config_path      = $::cirrus_curator::params::config_path,
  $actions_dir      = $::cirrus_curator::params::actions_dir,
  $config_user      = $::cirrus_curator::params::config_user,
  $config_group     = $::cirrus_curator::params::config_group,
  $config_template  = $::cirrus_curator::params::config_template,
)
{
  File {
    owner => $config_user,
    group => $config_group,
  }

  if $cirrus_curator::client_config == undef {
    $_client_config = {
      hosts       => ['localhost'],
      port        => '9200',
      use_ssl     => 'False',
      timeout     => '30',
      master_only => 'True'
    }
  }
  else {
    $_client_config = $cirrus_curator::client_config
  }

  if $cirrus_curator::logging_config == undef {
    $_logging_config = {
      loglevel  => 'INFO',
      logfile   => '/var/log/elasticsearch/curator.log',
      logformat => 'default',
    }
  }
  else {
    $_logging_config = $cirrus_curator::logging_config
  }

  file { '/etc/logrotate.d/curator':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/cirrus_curator/logrotate/curator',
  }

  file { $config_dir:
    ensure       => directory,
    purge        => $config_dir_purge,
    recurse      => $config_dir_purge,
    recurselimit => 1,
  }

  file { $config_path:
    ensure  => file,
    content => template($config_template),
    require => File[$config_dir],
  }

  file { $actions_dir:
    ensure  => directory,
    purge   => $config_dir_purge,
    recurse => $config_dir_purge,
    require => File[$config_dir],
  }
}
