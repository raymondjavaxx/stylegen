# frozen_string_literal: true

require 'stylegen/indent'

module Stylegen
  class Color
    attr_reader :red, :green, :blue, :alpha

    SIX_DIGIT_HEX_REGEX = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/.freeze
    THREE_DIGIT_HEX_REGEX = /^#?([a-f\d])([a-f\d])([a-f\d])$/.freeze
    MAX_PRECISION = 16

    def initialize(red, green, blue, alpha)
      @red = red
      @green = green
      @blue = blue
      @alpha = alpha
    end

    def self.from_hex(hex, alpha = nil)
      if (match = hex.downcase.match(SIX_DIGIT_HEX_REGEX))
        r = Integer(match.captures[0], 16) / 255.0
        g = Integer(match.captures[1], 16) / 255.0
        b = Integer(match.captures[2], 16) / 255.0
      elsif (match = hex.downcase.match(THREE_DIGIT_HEX_REGEX))
        r = Integer(match.captures[0] * 2, 16) / 255.0
        g = Integer(match.captures[1] * 2, 16) / 255.0
        b = Integer(match.captures[2] * 2, 16) / 255.0
      else
        raise ArgumentError, "Invalid color syntax: #{hex}"
      end

      Color.new(
        r.round(MAX_PRECISION),
        g.round(MAX_PRECISION),
        b.round(MAX_PRECISION),
        alpha || 1.0
      )
    end

    def grayscale?
      @red == @green && @green == @blue
    end

    def to_s(struct_name, indent = 0)
      Indent.with_level(indent) do
        if grayscale?
          "#{struct_name}(white: #{@red}, alpha: #{@alpha})"
        else
          <<~SWIFT.chomp
            #{struct_name}(
                red: #{@red},
                green: #{@green},
                blue: #{@blue},
                alpha: #{@alpha}
            )
          SWIFT
        end
      end
    end
  end
end
