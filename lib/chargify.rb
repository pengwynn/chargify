require 'hashie'
require 'httparty'
require "json"

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

require File.join(directory, 'chargify', 'client')
