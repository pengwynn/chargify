unless ENV['NO_RUBYGEMS']
  require 'rubygems'
  gem 'test-unit'
end
require 'test/unit'
require 'pathname'

require 'shoulda'
require 'matchy'
require 'mocha'
require 'fakeweb'
require 'chargify'

class Test::Unit::TestCase
end

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end


def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, url, options)
end

def stub_post(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:post, url, options)
end

def stub_put(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:put, url, options)
end

def stub_delete(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:delete, url, options)
end
