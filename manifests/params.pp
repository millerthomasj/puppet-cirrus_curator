# Class cirrus_curator::params
#
# Default configuration for curator module
#
class cirrus_curator::params {
  $ensure       = 'latest'
  $package_name = 'python-elasticsearch-curator'
  $provider     = 'apt'
  $manage_repo  = false
  $repo_version = false

  $bin_path = '/usr/local/bin/curator'
  $config_dir = '/etc/curator'
  $config_dir_purge = true
  $config_filename = 'curator.yml'
  $config_path = "${config_dir}/${config_filename}"

  $config_template = 'cirrus_curator/curator.yml.erb'
  $actions_dir = "${config_dir}/actions.d"
  $config_user = 'root'
  $config_group = 'root'
  $cron_hour = 6
  $cron_minute = 30
  $cron_month = '*'
  $cron_monthday = '*'
  $cron_weekday = '*'

  $client_config = undef
  $logging_config = undef
}
