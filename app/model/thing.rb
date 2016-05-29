require 'data_mapper'
require 'httparty'

module Model

  class Thing
    include DataMapper::Resource

    property :id, Serial
    property :name, Text
    property :description, Text
    property :address, Text
    property :state, Text
    has n, :actions

    class Action
      include DataMapper::Resource

      property :id, Serial
      property :name, Text
      property :state, Text
      belongs_to :thing

      def execute
        response = HTTParty.get "http://#{self.thing.address}?action=#{self[:name]}"

        self.thing.state = self[:state]
        self.thing.save!

        response.body.eql?('OK')
      end

    end
  end
end