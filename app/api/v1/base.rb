# encoding: UTF-8

require 'grape'
require 'api/v1/thing'
require 'model/thing'

module API

  module V1

    class Base < Grape::API
      version 'v1', :using => :header, :vendor => 'alienlabz', :format => :json

      mount API::V1::Thing => '/'
    end

  end

end
