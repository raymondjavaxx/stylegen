require 'json_schemer'

module Stylegen
  class Validator
    def valid?(config)
      schema.valid?(config)
    end

    def validate(config)
      errors = []

      schema.validate(config).each do |v|
        errors << JSONSchemer::Errors.pretty(v) unless v["type"] == "schema"
      end

      errors
    end

    private

    def schema
      @schema ||= JSONSchemer.schema(File.read(File.join(__dir__, "schema.json")))
    end
  end
end
