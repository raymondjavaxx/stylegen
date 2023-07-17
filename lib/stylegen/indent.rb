# frozen_string_literal: true

module Stylegen
  class Indent
    def initialize(level, string = nil)
      @level = level
      @data = []
      @data << string unless string.nil?
    end

    def <<(string)
      @data << string
    end

    def to_s
      result = @data.join.lines.map do |line|
        if line.strip.empty?
          line
        else
          "#{' ' * @level}#{line}"
        end
      end
      result.join
    end

    def self.with_level(level)
      indent = Indent.new(level)
      indent << yield
      indent.to_s
    end
  end
end
