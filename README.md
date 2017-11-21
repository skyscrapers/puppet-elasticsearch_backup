# Elasticsearch Backups Puppet Module

## Module description

This module sets up [Elasticsearch](https://www.elastic.co/overview/elasticsearch/) snapshots.

## Setup

### The module manages the following

* Elasticsearch snapshots.

### Requirements

* [elastic-elasticsearch](https://forge.puppet.com/elastic/elasticsearch)

## Usage

### Examples

#### Puppet manifest

```puppet
  class { 'elasticsearch_backup':
    type             => 's3',
    bucket           => 'fancy-s3-bucket-name',
    base_path        => $::hostname,
    region           => 'eu-west-1',
    script_path      => '/usr/local/bin',
    snapshot_name    => 'backup',
    snapshot_age     => 14,
    cronjob          => true,
    cron_starthour   => 6,
    cron_startminute => 22,
  }
```

#### Hiera

```
yaml
---
  elasticsearch_backup::type: 's3'
  elasticsearch_backup::bucket: 'fancy-s3-bucket-name'
  elasticsearch_backup::base_path: %{::hostname}
  elasticsearch_backup::region: 'eu-west-1'
  elasticsearch_backup::script_path: '/usr/local/bin'
  elasticsearch_backup::snapshot_name: 'backup'
  elasticsearch_backup::snapshot_age: 14
  elasticsearch_backup::cronjob: true
  elasticsearch_backup::cron_starthour: 6
  elasticsearch_backup::cron_startminute: 22
```
