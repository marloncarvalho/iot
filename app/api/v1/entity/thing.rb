# encoding: utf-8

require 'grape-entity'

module Entity

  class Action < Grape::Entity
    expose :id
    expose :name
  end

  class Thing < Grape::Entity
    expose :id
    expose :name
    expose :description
    expose :address
    expose :state
    expose :actions, :using => Action
  end

end
