module Stylegen
  class Color
    def initialize(r, g, b, a)
      @red, @green, @blue, @alpha = r, g, b, a
    end

    def self.from_hex(hex, alpha=nil)
      match = hex.downcase.match /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/

      r = Integer(match.captures[0], 16) / 255.0
      g = Integer(match.captures[1], 16) / 255.0
      b = Integer(match.captures[2], 16) / 255.0

      max_digits = 2

      Color.new(r.round(max_digits), g.round(max_digits), b.round(max_digits), alpha || 1.0)
    end

    def is_grayscale
      @red == @green && @green == @blue
    end

    def to_s(indent=0)
      if is_grayscale
        "UIColor(white: #{@red}, alpha: #{@alpha})"
      else
        "UIColor(red: #{@red}, green: #{@green}, blue: #{@blue}, alpha: #{@alpha})"
      end
    end
  end
end
