module Stylegen
  class BaseElevatedColor
    def initialize(base, elevated)
      @base, @elevated = base, elevated
    end

    def to_s(indent=0)
      indent_prefix = " " * indent

      result = ""
      result << "UIColor(\n"
      result << indent_prefix + "    base: #{@base.to_s(indent + 4)},\n"
      result << indent_prefix + "    elevated: #{@elevated.to_s(indent + 4)}\n"
      result << indent_prefix + ")"

      result
    end
  end
end
