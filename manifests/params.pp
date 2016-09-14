# Class curator::params
#
# Default configuration for curator module
#
class curator::params {
  $ensure       = '4.1.0'
  $package_name = 'elasticsearch-curator'
  $provider     = 'pip'
  $manage_repo  = false
  $repo_version = false

  # Defaults used for jobs, set through the class to make it easy to override
  $bin_file             = '/bin/curator'
  $host                 = 'localhost'
  $port                 = 9200
  $use_ssl              = false
  $ssl_validate         = false
  $ssl_certificate_path = undef
  $http_auth            = false
  $user                 = undef
  $password             = undef
  $jobs                 = {}
  $logfile              = '/var/log/curator.log'
  $log_level            = 'INFO'
  $logformat            = 'default'
}
