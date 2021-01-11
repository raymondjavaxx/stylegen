require 'dry/inflector'
require 'stylegen/version'
require 'stylegen/colors'

module Stylegen
  class Data
    def initialize(data)
      @data = data
    end

    def inflector
      @inflector ||= Dry::Inflector.new
    end

    def version
      Stylegen::VERSION
    end

    def system_name
      @data["system_name"] || "Theme"
    end

    def util_method_name
      inflector.camelize_lower(inflector.underscore(system_name))
    end

    def output_path
      @data["output_path"]
    end

    def basename
      File.basename(@data["output_path"])
    end

    def access_level
      @data["access_level"] || "internal"
    end

    def enum_name
      "#{system_name}Color"
    end

    def enum_members
      @data["colors"].each do |key, value|
        yield inflector.camelize_lower(key)
      end
    end

    def colors
      @data["colors"].each do |key, value|
        yield inflector.camelize_lower(key), _generate_color(value)
      end
    end

    def _generate_color(data)
      if data.key?("color")
        Color.from_hex(data["color"], data["alpha"])
      elsif data.key?("light")
        LightDarkColor.new(
            _generate_color(data["light"]),
            _generate_color(data["dark"])
        )
      elsif data.key?("base")
        BaseElevatedColor.new(
            _generate_color(data["base"]),
            _generate_color(data["elevated"])
        )
      end
    end
  end
end
