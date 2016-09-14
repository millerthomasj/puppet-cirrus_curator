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
define cirrus_elasticsearch::curator::action_file (
  $content       = undef,
  $source        = undef,
  $cron_ensure   = undef,
  $cron_hour     = $::cirrus_elasticsearch::params::curator_hour,
  $cron_minute   = $::cirrus_elasticsearch::params::curator_minute,
  $cron_month    = $::cirrus_elasticsearch::params::curator_month,
  $cron_monthday = $::cirrus_elasticsearch::params::curator_cron_monthday,
  $cron_weekday  = $::cirrus_elasticsearch::params::curator_cron_weekday,
  $actions_dir   = $::cirrus_elasticsearch::params::curator_actions_dir,
  $bin_path      = $::cirrus_elasticsearch::params::curator_bin_path,
  $config_path   = $::cirrus_elasticsearch::params::curator_config_path,
  $group         = $::cirrus_elasticsearch::params::curator_config_group,
  $user          = $::cirrus_elasticsearch::params::curator_config_user,
)
{
  include ::cirrus_elasticsearch::params
  include ::cirrus_elasticsearch::curator::config

  $actionfile_name = "${actions_dir}/${name}.action.yml"

  if ( $content != undef ) or ( $source != undef ) {
    if ( $content != undef ) {
      $_content = $content
    }
    else {
      $_content = file($source)
    }

    file { "curator_${name}_actionfile":
      ensure  => file,
      path    => $actionfile_name,
      content => $_content,
      owner   => $user,
      group   => $group,
      mode    => '0644',
    }

    if ( $cron_ensure != undef ) {
      cron { "curator_${name}_cron":
        ensure   => $cron_ensure,
        command  => "${bin_path} --config ${config_path} ${actionfile_name} >/dev/null",
        hour     => $cron_hour,
        minute   => $cron_minute,
        month    => $cron_month,
        monthday => $cron_monthday,
        weekday  => $cron_weekday,
        user     => $user,
      }
    }
  }
}
