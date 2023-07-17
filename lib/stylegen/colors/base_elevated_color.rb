# frozen_string_literal: true

require 'stylegen/indent'

module Stylegen
  class BaseElevatedColor
    attr_reader :description

    def initialize(base, elevated)
      @base = base
      @elevated = elevated
    end

    def to_s(struct_name, indent = 0)
      Indent.with_level(indent) do
        <<~SWIFT.chomp
          #{struct_name}(
              base: #{@base.to_s(struct_name, 4).lstrip},
              elevated: #{@elevated.to_s(struct_name, 4).lstrip}
          )
        SWIFT
      end
    end
  end
end
