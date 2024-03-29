# frozen_string_literal: true

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

    def custom_header
      @data['header']
    end

    def version
      Stylegen::VERSION
    end

    def system_name
      @data['system_name'] || 'Theme'
    end

    def util_method_name
      inflector.camelize_lower(inflector.underscore(system_name))
    end

    def output_path
      @data['output_path']
    end

    def frameworks
      @data['frameworks'] || ['UIKit']
    end

    def supports_uikit?
      frameworks.include?('UIKit')
    end

    def supports_appkit?
      frameworks.include?('AppKit')
    end

    def multiplatform?
      supports_uikit? && supports_appkit?
    end

    def swiftui?
      @data['swiftui'] || false
    end

    def basename
      File.basename(@data['output_path'])
    end

    def access_level
      @data['access_level'] || 'internal'
    end

    def effective_access_level
      access_level == 'internal' ? '' : access_level
    end

    def struct_name
      "#{system_name}Color"
    end

    def color_entries
      @color_entries ||= @data['colors'].map do |key, value|
        {
          property: inflector.camelize_lower(key),
          description: value['description'],
          color: generate_color(value)
        }
      end
    end

    private

    def generate_color(data)
      if data.is_a?(String)
        Color.from_hex(data)
      elsif data.key?('color')
        Color.from_hex(data['color'], data['alpha'])
      elsif data.key?('light')
        LightDarkColor.new(
          generate_color(data['light']),
          generate_color(data['dark'])
        )
      elsif data.key?('base')
        BaseElevatedColor.new(
          generate_color(data['base']),
          generate_color(data['elevated'])
        )
      end
    end
  end
end
