# -*- encoding: utf-8 -*-

require File.dirname(__FILE__) + '/lib/chargify.rb'

Gem::Specification.new do |s|
  s.name = %q{chargify}
  s.version = Chargify::VERSION.dup
  s.authors = ["Wynn Netherland", "Nash Kabbara"]
  s.email = %q{wynn.netherland@gmail.com}
  s.homepage = %q{http://github.com/pengwynn/chargify}
  s.summary = %q{Ruby wrapper for the chargify.com SAAS and billing API}
  s.description = %q{Ruby wrapper for the chargify.com SAAS and billing API using httparty}
  s.extra_rdoc_files = [ "LICENSE", "README.markdown" ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.required_rubygems_version = ">= 1.3.6"
  s.files = %w{.document .gitignore LICENSE README.markdown Rakefile changelog.md chargify.gemspec} +
    Dir.glob(['{lib,test}/**/*.rb', 'test/fixtures/*.json'])
  s.test_files = [ "test/helper.rb", "test/chargify_test.rb" ]

  s.add_runtime_dependency(%q<hashie>, ["~> 1.2"])
  s.add_runtime_dependency(%q<httparty>, ["~> 0.8"])
  s.add_development_dependency(%q<shoulda>, [">= 2.10.1"])
  s.add_development_dependency(%q<jnunemaker-matchy>, ["= 0.4.0"])
  s.add_development_dependency(%q<mocha>, ["~> 0.9.8"])
  s.add_development_dependency(%q<fakeweb>, [">= 1.2.5"])
  s.add_development_dependency('mg', ['>= 0.0.8'])
  s.add_development_dependency('test-unit', ['>= 2.3.0'])
end
