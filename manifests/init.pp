# == Class: elasticsearch::snapshot
#
# This class is able to activate snapshots for elasticsearch
#
#
# === Parameters
#
# [*snapshot_name*]
#   Name of snapshot repository.
#
# [*type*]
#   Snapshot type. eg: 's3' or 'fs'
#
# [*location]
#   Where to save the snapshots on the filesystem.
#
# [*bucket*]
#   S3 bucket where to upload the snapshot. Used only if type == 's3'
#
# [*region*]
#   AWS region where the S3 bucket is. Used only if type == 's3'
#
# [*base_path*]
#   Directory inside the S3 bucket where to place the snapshots. Used only if type == 's3'
#
# [*script_path*]
#   Where to place the backup script.
#
# [*cronjob*]
#   Whether to setup a cronjob to take the snapshots or not. Valid values are: true and false
#
# [*cron_starthour*]
#   At which hour the cron should run? Used only if cronjob == true
#
# [*cron_startminute*]
#   At which minute the cron should run? Used only if cronjob == true
#
# [*snapshot_age*]
#   Snapshot older than this age (days) will be deleted. Defaults to 14
#
# === Examples
#
#   class { 'elasticsearch_backup':
#     type             => 's3',
#     bucket           => 'fancy-s3-bucket-name',
#     base_path        => $::hostname,
#     region           => 'eu-west-1',
#     script_path      => '/usr/local/bin',
#     snapshot_name    => 'backup',
#     snapshot_age     => 14,
#     cronjob          => true,
#     cron_starthour   => 6,
#     cron_startminute => 22,
#   }
#
class elasticsearch_backup(
  $snapshot_name    = undef,
  $location         = undef,
  $bucket           = undef,
  $region           = undef,
  $base_path        = undef,
  $cronjob          = false,
  $cron_starthour   = $elasticsearch_backup::params::cron_starthour,
  $cron_startminute = $elasticsearch_backup::params::cron_startminute,
  $script_path      = $elasticsearch_backup::params::snapshot_script_path,
  $snapshot_age     = $elasticsearch_backup::params::snapshot_age,
  $type             = $elasticsearch_backup::params::snapshot_type,
) inherits elasticsearch_backup::params {

  if ($type == 'fs') {
    $settings = "{\"location\": \"${location}\",\"compress\": true}"
  } elsif ($type == 's3') {
    if ($base_path) {
      $settings = "{\"bucket\": \"${bucket}\",\"region\": \"${region}\",\"base_path\": \"${base_path}\"}"
    } else {
      $settings = "{\"bucket\": \"${bucket}\",\"region\": \"${region}\"}"
    }
  }

  exec { 'Add snapshot to elasticsearch':
    command   => "curl -XPUT \'http://localhost:9200/_snapshot/${snapshot_name}\' -d \'{\"type\": \"${type}\",\"settings\": ${settings}}\'",
    unless    => "curl -XGET \'http://localhost:9200/_snapshot/_all\' | grep ${snapshot_name}",
    path      => '/usr/bin/:/bin/',
    logoutput => true,
  }

  file { "${script_path}/elasticsearch_backup.py":
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0775',
      source => 'puppet:///modules/elasticsearch/elasticsearch_backup.py',
  }

  if ( $type == 'fs' ) {
    file { $location:
      ensure => directory,
      mode   => '0755',
      owner  => 'elasticsearch',
      group  => 'elasticsearch',
    }
  }

  if $cronjob {
    file { '/etc/cron.d/elasticsearch':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('elasticsearch/etc/cron.d/elasticsearch.erb'),
    }
  }
}
