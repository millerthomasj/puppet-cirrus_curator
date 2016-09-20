class cirrus_curator::install
{
  case ($cirrus_curator::manage_repo) {
    true: {
      case $::osfamily {
        'Debian': {
          $_package_name = 'python-elasticsearch-curator'
          $_provider     = 'apt'
        }
        'RedHat': {
          $_package_name = 'python-elasticsearch-curator'
          $_provider     = 'yum'
        }
        default: {
          $_package_name = 'elasticsearch-curator'
          $_provider     = 'pip'
        }
      }
    }
    default: {
      $_package_name = $cirrus_curator::package_name
      $_provider     = $cirrus_curator::provider
    }
  }
notify { "testing $cirrus_curator::manage_repo": }
  if ($cirrus_curator::manage_repo == true) {
    # Set up repositories
    class { '::cirrus_curator::repo': } ->
    package { $_package_name:
      ensure   => $cirrus_curator::ensure,
      provider => $_provider,
    }
  } else {
    package { $_package_name:
      ensure   => $cirrus_curator::ensure,
      provider => $_provider,
    }
  }
}
