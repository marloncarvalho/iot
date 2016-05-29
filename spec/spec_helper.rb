require 'rubygems'
require 'airborne'
require 'rack/test'
require 'dm-rspec'
require 'dotenv'

Dotenv.load

ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

DataMapper.setup(:default, ENV['DATABASE_TEST_URL'])
DataMapper::finalize
DataMapper.auto_migrate!

Airborne.configure do |config|
  config.base_url = 'http://localhost:5000/'
  config.rack_app = API::Base
  config.include(DataMapper::Matchers)
end