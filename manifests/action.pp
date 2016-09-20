# == Define: cirrus_elasticsearch::curator::action_file
#
# Creates an Action File for Curator to manage Elasticsearch indices.
#
# Note: Prior to Curator version 3.0.0, the following 'Order of Operations' was
#       enforced to prevent operations from colliding:
#           delete -> close -> forcemerge
#       While the Action File format for version 4.0.0+ promises to execute
#       actions in the order listed, it is still wise to follow the above order
#       when creating a series of actions.
#
# === Parameters
#
# [*content*]
#  Hash. Provide content for entire action file as a single hash. Useful with
#  Hiera, such that a single Hiera key can set all paramters used in this
#  define, where the top-level key would be the $title or $name of this define,
#  "content:" would be a second-level key, and the entirety of the action file
#  would be nested as the value of "content:". If both $content and $source
#  are provided, only $content is used.
#
# [*source*]
#  String. Provide a source file to be used as action file.
#
# [*cron_ensure*]
#  String. The basic property that the resource should be in.
#  Valid values are 'present' or 'absent'.
#

define cirrus_curator::action (
  $action = undef,
  $description = undef,
  $continue_if_exception = 'False',
  $disable_action = 'False',
  $pattern_value = 'logstash-',
  $age_source = 'name',
  $age_timestring = '%Y.%m.%d',
  $age_older_unit_count = 7,
  $age_younger_unit_count = 14,
  $cron_hour = 6,
  $cron_minute = 30,
  $cron_month = '*',
  $cron_monthday = '*',
  $cron_weekday = '*',
  $user = 'root',
)
{
  require ::cirrus_curator::config

  $actionfile_name = "${::cirrus_curator::actions_dir}/${name}.action.yml"

  file { $actionfile_name:
    ensure  => file,
    content => template('cirrus_curator/action.yml.erb'),
    owner   => $user,
    group   => $user,
    mode    => '0644',
  }

  if ( $disable_action != 'True' ) {
    $_ensure = 'present'
  }
  else {
    $_ensure = 'absent'
  }

  cron { "curator_${name}_cron":
    ensure   => $_ensure,
    command  => "${::cirrus_curator::bin_path} --config ${cirrus_curator::params::config_path} ${actionfile_name} >/dev/null",
    hour     => $cron_hour,
    minute   => $cron_minute,
    month    => $cron_month,
    monthday => $cron_monthday,
    weekday  => $cron_weekday,
    user     => $user,
  }
}
