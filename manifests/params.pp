# == Class: elasticsearch_backup::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
class elasticsearch_backup::params {
  # Default values for the parameters of the main module class, init.pp
  $snapshot_type        = 'fs'
  $snapshot_script_path = '/usr/local/bin'
  $snapshot_age         = '14'
  $cron_starthour       = '2'
  $cron_startminute     = '0'
}
