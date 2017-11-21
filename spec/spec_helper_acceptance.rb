require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/librarian'

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install puppet
    run_puppet_install_helper_on(hosts)
    # Install librarian-puppet
    install_librarian
    # Transfer module and install dependencies based on Puppetfile/metadata.json
    librarian_install_modules(proj_root, 'elasticsearch_backup')
  end
end
