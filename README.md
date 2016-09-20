#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with cirrus_curator](#setup)
    * [What cirrus_curator affects](#what-cirrus_curator-affects)
    * [Beginning with cirrus_curator](#beginning-with-cirrus_curator)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)

## Overview

A puppet module for installing and configuring [elastic-cirrus_curator](https://github.com/elastic/cirrus_curator).

## Module Description

Curator is used to manage and clean up time-series elasticsearch indexes, this module manages curator.

NOTE: If you are using curator < 4.0.0 use a previous version of this module.

## Setup

### What cirrus_curator affects

* curator package
* curator cron jobs

## Usage

Generic cirrus_curator install via pip (requires pip is installed)
```puppet
  class { 'cirrus_curator': }
```

Install via yum
```puppet
  class { 'cirrus_curator':
    package_name => 'python-elasticsearch-cirrus_curator',
    provider     => 'yum'
  }
```

Close indexes over 2 days old
```puppet
  cirrus_curator::action { 'logstash_close':
    action      => 'close',
    older_than  => 2,
    cron_hour   => 7,
    cron_minute => 20,
  }
```

Delete marvel indexes older than a week
```puppet
  cirrus_curator::action { 'marvel_delete':
    action       => 'delete',
    prefix       => '.marvel-',
    older_than   => 7,
    cron_hour    => 7,
    cron_minute  => 02
  }
```

Use hiera for your actions
```puppet
cirrus_curator::actions:
  logstash_close:
    action: close
    older_than: 2
    cron_hour: 2
    cron_minute: 20
  marvel_delete:
    action: delete
    prefix: '.marvel'
    older_than: 7
    cron_hour: 7
    cron_minute: 20
```

Currently this package supports installing cirrus_curator via pip or your local
package manager.  RPM packages can easly be created by running:

```
fpm -s python -t rpm urllib3
fpm -s python -t rpm elasticsearch
fpm -s python -t rpm click
fpm -s python -t rpm elasticsearch-cirrus_curator
```
