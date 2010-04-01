require 'rake'
require 'shoulda/tasks'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "chargify"
    gem.summary = %Q{Ruby wrapper for the chargify.com SAAS and billing API}
    gem.description = %Q{Ruby wrapper for the chargify.com SAAS and billing API}
    gem.email = "wynn.netherland@gmail.com"
    gem.homepage = "http://github.com/pengwynn/chargify"
    gem.authors = ["Wynn Netherland","Nash Kabbara"]
    
    gem.add_dependency('hashie', '~> 0.1.3')
    gem.add_dependency('httparty', '~> 0.4.5')

    gem.add_development_dependency('thoughtbot-shoulda', '>= 2.10.1')
    gem.add_development_dependency('jnunemaker-matchy', '0.4.0')
    gem.add_development_dependency('mocha', '0.9.4')
    gem.add_development_dependency('fakeweb', '>= 1.2.5')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "chargify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
