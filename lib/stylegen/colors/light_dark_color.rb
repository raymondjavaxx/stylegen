# frozen_string_literal: true

module Stylegen
  class LightDarkColor
    def initialize(light, dark)
      @light, @dark = light, dark
    end

    def to_s(indent=0)
      indent_prefix = " " * indent

      result = []
      result << "UIColor("
      result << indent_prefix + "    light: #{@light.to_s(indent + 4)},"
      result << indent_prefix + "    dark: #{@dark.to_s(indent + 4)}"
      result << indent_prefix + ")"

      result.join("\n")
    end
  end
end
