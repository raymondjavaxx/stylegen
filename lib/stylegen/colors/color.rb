# frozen_string_literal: true

module Stylegen
  class Color
    attr_reader :red, :green, :blue, :alpha

    def initialize(r, g, b, a)
      @red, @green, @blue, @alpha = r, g, b, a
    end

    def self.from_hex(hex, alpha = nil)
      if (match = hex.downcase.match(/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/))
        r = Integer(match.captures[0], 16) / 255.0
        g = Integer(match.captures[1], 16) / 255.0
        b = Integer(match.captures[2], 16) / 255.0
      elsif (match = hex.downcase.match(/^#?([a-f\d])([a-f\d])([a-f\d])$/))
        r = Integer(match.captures[0] * 2, 16) / 255.0
        g = Integer(match.captures[1] * 2, 16) / 255.0
        b = Integer(match.captures[2] * 2, 16) / 255.0
      else
        raise ArgumentError, "Invalid color syntax: #{hex}"
      end

      max_precision = 16

      Color.new(r.round(max_precision), g.round(max_precision), b.round(max_precision), alpha || 1.0)
    end

    def grayscale?
      @red == @green && @green == @blue
    end

    def to_s(struct_name, indent = 0)
      if grayscale?
        "#{struct_name}(white: #{@red}, alpha: #{@alpha})"
      else
        indent_prefix = " " * indent

        result = []
        result << "#{struct_name}("
        result << "#{indent_prefix}    red: #{@red},"
        result << "#{indent_prefix}    green: #{@green},"
        result << "#{indent_prefix}    blue: #{@blue},"
        result << "#{indent_prefix}    alpha: #{@alpha}"
        result << "#{indent_prefix})"

        result.join("\n")
      end
    end
  end
end
