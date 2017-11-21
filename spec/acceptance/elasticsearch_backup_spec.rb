require 'spec_helper_acceptance'

describe '::elasticsearch_backup' do
  describe 'running puppet code' do
    let(:manifest) {
      <<-EOS
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
      EOS
    }

    it 'should run without errors' do
      result = apply_manifest(manifest, :catch_failures => true)
      expect(@result.exit_code).to be <= 2
    end

    describe file('/etc/cron.d/elasticsearch') do
      it { should be_file }
    end

    it 'should run a second time without changes' do
      # Run it twice and test for idempotency
      result = apply_manifest(manifest, :catch_failures => true)
      expect(@result.exit_code).to eq 0
    end
  end
end
