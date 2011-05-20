require "mg"
require 'shoulda/tasks'

MG.new("chargify.gemspec")

desc 'Run tests'
task :test do
  sh 'testrb -I. -Ilib -Itest test/*_test.rb'
end

task :default => :test
