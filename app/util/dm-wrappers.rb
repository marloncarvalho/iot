module DataMapper

  module Resource
    alias_method :save?, :save

    def save
      return true if self.save? || self.errors.empty?
      raise DataMapper::ValidationFailureError.new(self)
    end
  end

  class ValidationFailureError < DataMapper::PersistenceError
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

  end

end