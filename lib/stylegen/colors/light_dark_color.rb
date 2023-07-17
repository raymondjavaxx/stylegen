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
        <<~SWIFT
          #{struct_name}(
              light: #{@light.to_s(struct_name, indent + 4)},
              dark: #{@dark.to_s(struct_name, indent + 4)}
          )
        SWIFT
      end.strip
    end
  end
end
