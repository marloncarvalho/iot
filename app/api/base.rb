# encoding: UTF-8

require 'grape'
require 'api/v1/base'

module API

  class Base < Grape::API
    mount API::V1::Base
  end

end
