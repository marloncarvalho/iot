# encoding: utf-8

module Entity

  class Error
    attr_accessor :code, :description, :details, :url

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      @details = Array.new
    end

    def to_json
      details = ""

      @details.each do |d|
        messages = ""
        d.messages.each do |m|
          messages += "\"#{m}\","
        end

        details += "{\"messages\":[#{messages[0..-2]}],\"cause\":\"#{d.cause}\"},"
      end

      "{\"code\":\"#{@code}\",\"description\":\"#{@description}\",\"url\":\"#{@url}\",\"details\":[#{details[0..-2]}]}"
    end

    class Detail
      attr_accessor :messages, :cause

      def initialize args
        args.each do |k,v|
          instance_variable_set("@#{k}", v) unless v.nil?
        end
      end
    end

  end

end