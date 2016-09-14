class cirrus_curator::params
{
  ## Curator installation defaults
  $curator_bin_path = '/usr/local/bin/curator'
  $curator_ensure = 'latest'
  $curator_package_name = 'python-elasticsearch-curator'
  $curator_provider = 'apt'

  ## Curator config, action files, and crontab defaults
  $curator_config_dir = '/etc/curator'
  $curator_config_dir_purge = true
  $curator_config_filename = 'curator.yml'
  $curator_config_path = "${curator_config_dir}/${curator_config_filename}"
  $curator_config_template = 'cirrus_elasticsearch/curator.yml.erb'
  $curator_actions_dir = "${curator_config_dir}/actions.d"
  $curator_config_group = 'root'
  $curator_config_user = 'root'
  $curator_log_level = 'INFO'
  $curator_log_file = '/var/log/curator.log'
  $curator_log_format = 'default'
  $curator_master_only = true
  $curator_cron_hour = 6
  $curator_cron_minute = 30
  $curator_cron_month = '*'
  $curator_cron_monthday = '*'
  $curator_cron_weekday = '*'
}
