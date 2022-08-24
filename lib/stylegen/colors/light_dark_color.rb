# frozen_string_literal: true

module Stylegen
  class LightDarkColor
    def initialize(light, dark)
      @light = light
      @dark = dark
    end

    def to_s(struct_name, indent = 0)
      indent_prefix = ' ' * indent

      result = []
      result << "#{struct_name}("
      result << "#{indent_prefix}    light: #{@light.to_s(struct_name, indent + 4)},"
      result << "#{indent_prefix}    dark: #{@dark.to_s(struct_name, indent + 4)}"
      result << "#{indent_prefix})"

      result.join("\n")
    end
  end
end
