# frozen_string_literal: true

module Stylegen
  class BaseElevatedColor
    attr_reader :description

    def initialize(base, elevated)
      @base, @elevated = base, elevated
    end

    def to_s(struct_name, indent = 0)
      indent_prefix = " " * indent

      result = []
      result << "#{struct_name}("
      result << "#{indent_prefix}    base: #{@base.to_s(struct_name, indent + 4)},"
      result << "#{indent_prefix}    elevated: #{@elevated.to_s(struct_name, indent + 4)}"
      result << "#{indent_prefix})"

      result.join("\n")
    end
  end
end
