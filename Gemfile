source 'https://rubygems.org'

group :development, :test do
  gem 'json', :require => false
  gem 'metadata-json-lint', :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet-lint', :require => false
  gem 'rake', :require => false
  gem 'rspec-puppet', :require => false
  gem 'test-unit', :require => false
  gem 'minitest', :require => false
  gem 'librarian-puppet', :require => false
  gem 'travis', :require => false
  gem 'safe_yaml', '~> 1.0.4'
end

group :acceptance do
  gem 'beaker', :require => false
  gem 'beaker-librarian', :git => 'https://github.com/skyscrapers/beaker-librarian.git', :branch => 'install_rubygems', :require => false
  gem 'beaker-rspec', :require => false
  gem 'beaker-puppet_install_helper', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

facterversion = ENV['GEM_FACTER_VERSION'] || ENV['FACTER_GEM_VERSION']
if facterversion
  gem 'facter', *location_for(facterversion)
else
  gem 'facter', :require => false
end
# vim:ft=ruby
