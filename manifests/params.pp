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

  $config_dir = '/etc/curator'
  $config_dir_purge = true
  $config_filename = 'curator.yml'
  $config_path = "${curator_config_dir}/${curator_config_filename}"

  $config_template = 'cirrus_elasticsearch/curator.yml.erb'
  $actions_dir = "${curator_config_dir}/actions.d"
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
