module Stylegen
  class LightDarkColor
    def initialize(light, dark)
      @light, @dark = light, dark
    end

    def to_s(indent=0)
      indent_prefix = " " * indent

      result = ""
      result << "UIColor(\n"
      result << indent_prefix + "    light: #{@light.to_s},\n"
      result << indent_prefix + "    dark: #{@dark.to_s}\n"
      result << indent_prefix + ")"

      result
    end
  end
end
