require File.expand_path('../config/environment', __FILE__)

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, 'postgres://postgres:stark@localhost:5432/iot')
#DataMapper.auto_migrate!
DataMapper::finalize

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options, :patch]
  end
end

run API::Base