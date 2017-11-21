require 'spec_helper'

describe 'elasticsearch_backup' do
  let(:title) { 'test' }
  let(:facts) do
      {
        :osfamily                  => 'Ubuntu',
        :operatingsystem           => 'Ubuntu'
        :hostname                  => 'ci.skyscrape.rs'
      }
  end

  context 'definition' do
    let(:params) do 
      {
        :type             => 's3',
        :bucket           => 'fancy-s3-bucket-name',
        :base_path        => $::hostname,
        :region           => 'eu-west-1',
        :location         => '/tmp/backups',
        :script_path      => '/usr/local/bin',
        :snapshot_name    => 'backup',
        :snapshot_age     => '14',
        :cronjob          => 'true',
        :cron_starthour   => '6',
        :cron_startminute => '22',
      }
    end

    it do
      is_expected.to compile
    end

  end

  context 'base execution' do
    let(:params) do 
      {
        :type             => 's3',
        :bucket           => 'fancy-s3-bucket-name',
        :base_path        => $::hostname,
        :region           => 'eu-west-1',
        :location         => '/tmp/backups',
        :script_path      => '/usr/local/bin',
        :snapshot_name    => 'backup',
        :snapshot_age     => '14',
        :cronjob          => 'true',
        :cron_starthour   => '6',
        :cron_startminute => '22',
      }
    end

    it do
      is_expected.to contain_file('/usr/local/bin/elasticsearch_backup.py').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0775',
		)
    end
    it do
  		is_expected.to contain_file('/etc/cron.d/elasticsearch').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
		)
    end
    it do
  		is_expected.not_to contain_file('/tmp/backups')
  	end
  end

  context 'fs execution' do
    let(:params) do 
      {
        :type             => 'fs',
        :bucket           => 'fancy-s3-bucket-name',
        :base_path        => $::hostname,
        :region           => 'eu-west-1',
        :location         => '/tmp/backups',
        :script_path      => '/usr/local/bin',
        :snapshot_name    => 'backup',
        :snapshot_age     => 14,
        :cronjob          => true,
        :cron_starthour   => 6,
        :cron_startminute => 22,
      }
    end

    it do
      is_expected.to contain_file('/usr/local/bin/elasticsearch_backup.py').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0775',
		)
    end
    it do
  		is_expected.to contain_file('/etc/cron.d/elasticsearch').with(
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
		)
    end
    it do
  		is_expected.to contain_file('/tmp/backups').with(
        'ensure' => 'directory',
        'owner'  => 'elasticsearch',
        'group'  => 'elasticsearch',
        'mode'   => '0775',
		)
  	end
  end

end