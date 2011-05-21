require "mg"
require 'shoulda/tasks'

MG.new("chargify.gemspec")

desc 'Run tests'
task :test do
  sh 'testrb -I.:lib test/*_test.rb'
end

task :default => :test
