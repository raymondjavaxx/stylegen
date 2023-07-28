# frozen_string_literal: true

require 'stylegen/indent'

module Stylegen
  class LightDarkColor
    def initialize(light, dark)
      @light = light
      @dark = dark
    end

    def to_s(struct_name, indent = 0)
      Indent.with_level(indent) do
        <<~SWIFT.chomp
          #{struct_name}(
              light: #{@light.to_s(struct_name, 4).lstrip},
              dark: #{@dark.to_s(struct_name, 4).strip}
          )
        SWIFT
      end
    end
  end
end
